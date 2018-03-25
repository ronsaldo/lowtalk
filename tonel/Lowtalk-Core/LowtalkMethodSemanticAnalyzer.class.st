Class {
	#name : #LowtalkMethodSemanticAnalyzer,
	#superclass : #LowtalkSemanticAnalyzer,
	#instVars : [
		'method'
	],
	#classVars : [
		'BlockMessages',
		'BooleanControlFlowMessages'
	],
	#category : 'Lowtalk-Core-Interpreter'
}

{ #category : #initialization }
LowtalkMethodSemanticAnalyzer class >> initialize [
	BlockMessages := Dictionary newFromPairs: #(
		whileTrue WhileLoop
		whileTrue: WhileLoop
		whileFalse WhileLoop
		whileFalse: WhileLoop
		whileNotNil: WhileLoop
		whileNil: WhileLoop
	).
	
	BooleanControlFlowMessages := Set newFrom: #(
		ifTrue:
		ifFalse:
		
		ifTrue:ifFalse:
		ifFalse:ifTrue:
		
		whileTrue
		whileTrue:
		whileFalse
		whileFalse:
	).
]

{ #category : #'as yet unclassified' }
LowtalkMethodSemanticAnalyzer >> analyzeBlock: aBlockNode environment: baseEnvironment [
	^ self analyzeBlock: aBlockNode environment: baseEnvironment parentMethod: nil
]

{ #category : #'as yet unclassified' }
LowtalkMethodSemanticAnalyzer >> analyzeBlock: aBlockNode environment: baseEnvironment parentMethod: parentMethod [
	| blockEnvironment topEnvironment |
	compiler := baseEnvironment compiler.
	
	self withEnvironment: baseEnvironment do: [ 	
		self solveBlockType: aBlockNode.
	].

	method := LowtalkInterpreterMethod new node: aBlockNode.
	method
		type: aBlockNode type;
		hasLocalReturns: (aBlockNode hasPragmaNamed: #localReturn);
		parentMethod: parentMethod.
	aBlockNode pragmaAt: #selector: ifPresent: [ :pragma |
		self withEnvironment: baseEnvironment do: [ 	
			method selector: (self asEvaluator evaluateValue: pragma arguments first)
		]
	].
	aBlockNode pragmaAt: #primitive: ifPresent: [ :pragma |
		self withEnvironment: baseEnvironment do: [ 	
			method primitive: (self asEvaluator evaluateValue: pragma arguments first)
		]
	].
	
	topEnvironment := baseEnvironment.
	aBlockNode selfType isVoidType ifFalse: [
		topEnvironment := (LowtalkReceiverEnvironment parent: baseEnvironment)
			receiverType: aBlockNode selfType;
			receiver: method.
	].

	blockEnvironment := LowtalkLocalEnvironment parent: topEnvironment.
	method
		environment: blockEnvironment;
		returnType: aBlockNode returnType;
		receiverType: aBlockNode selfType.
	
	self withEnvironment: blockEnvironment do: [ 
		method arguments: (aBlockNode arguments collect: [ :argument | self visitNode: argument]).
			
		self visitNode: aBlockNode body
	].
	
	^ method
]

{ #category : #'as yet unclassified' }
LowtalkMethodSemanticAnalyzer >> analyzeMethod: methodNode receiverType: receiverType environment: baseEnvironment [
	| methodEnvironment topEnvironment arguments returnType argumentTypes callingConvention functionType |
	compiler := baseEnvironment compiler.

	self withEnvironment: baseEnvironment do: [
		"Solve the arguments first."
		arguments := methodNode arguments collect: [ :arg |
			LowtalkMethodArgument new
				definitionNode: arg;
				valueType: (self solveTypeExpression: arg typeExpression);
				name: arg name;
				isConstant: true.
		].

		"Solve the return type."
		returnType := self solveTypeExpression: methodNode returnTypeExpression defaultType: (receiverType asDefaultReturnTypeWith: compiler).
	].

	argumentTypes := arguments collect: #valueType.
	receiverType isVoidType ifFalse: [ 
		argumentTypes := { receiverType } , argumentTypes
	].

	callingConvention := compiler defaultCallingConvention.
	functionType := (LowtalkFunctionType target: self compiler compilationTarget)
			arguments: argumentTypes;
			returnType: returnType;
			callingConvention: callingConvention;
			yourself.

	method := LowtalkInterpreterMethod new node: methodNode.
	method
		type: functionType;
		hasLocalReturns: true.
	
	topEnvironment := (LowtalkReceiverEnvironment parent: baseEnvironment)
		receiverType: receiverType;
		receiver: method.

	methodEnvironment := LowtalkLocalEnvironment parent: topEnvironment.
	method
		environment: methodEnvironment;
		returnType: returnType;
		receiverType: receiverType;
		arguments: arguments;
		selector: methodNode selector.
	methodNode pragmaAt: #primitive: ifPresent: [ :pragma |
		self withEnvironment: baseEnvironment do: [ 	
			method primitive: (self asEvaluator evaluateValue: pragma arguments first)
		]
	].

	self withEnvironment: methodEnvironment do: [ 
		arguments do: [ :arg |
			arg method: method.
			environment setSymbol: arg name value: arg ifPresent: [ 
				arg definitionNode semanticError: 'Argument variable name {1} is already in use.' format: { arg name printString }
			].
		].
		
		self visitNode: methodNode body
	].
	
	^ method
]

{ #category : #'as yet unclassified' }
LowtalkMethodSemanticAnalyzer >> analyzeMethodSignature: methodNode receiverType: receiverType environment: baseEnvironment [
	| arguments returnType argumentTypes callingConvention functionType |
	compiler := baseEnvironment compiler.

	self withEnvironment: baseEnvironment do: [
		"Solve the arguments first."
		arguments := methodNode arguments collect: [ :arg |
			LowtalkMethodArgument new
				definitionNode: arg;
				valueType: (self solveTypeExpression: arg typeExpression);
				name: arg name;
				isConstant: true.
		].

		"Solve the return type."
		returnType := self solveTypeExpression: methodNode returnTypeExpression defaultType: (receiverType asDefaultReturnTypeWith: compiler).
	].

	argumentTypes := arguments collect: #valueType.
	receiverType isVoidType ifFalse: [ 
		argumentTypes := { receiverType } , argumentTypes
	].

	callingConvention := compiler defaultCallingConvention.
	functionType := (LowtalkFunctionType target: self compiler compilationTarget)
			arguments: argumentTypes;
			returnType: returnType;
			callingConvention: callingConvention;
			yourself.
	^ functionType
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> captureMethodVariable: methodVariable [
	self assert: methodVariable method isNotNil.
	methodVariable method == method ifTrue: [ ^ self ].
	
	methodVariable isCapturedInClosure: true.
	methodVariable method addCapturedVariable: methodVariable.
	method addOuterClosureVariable: methodVariable
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkAddressMessage: message receiver: receiver [
	| referenceType |
	referenceType := receiver type.
	referenceType isReferenceType ifFalse: [
		message semanticError: 'Expected a reference to extract an address'.
	].

	message type: referenceType withoutReferences pointer.
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> checkAndMessage: message receiver: receiver [
	| argument |
	self assert: message arguments size = 1.
	argument := message arguments first.
	self visitInlinedBlock: argument types: #() from: message.
	
	message setTypeIfNil: compiler booleanType.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkArithmeticMessage: message receiver: receiver [
	| leftType rightType left right coercionType |
	self assert: message arguments size = 1.
	left := receiver.
	leftType := receiver type withoutReferences.
	leftType isAggregateType ifTrue: [ ^ self checkNormalMessage: message receiver: receiver ].
	
	right := message arguments first.
	self visitNode: right.
	
	rightType := message arguments first type withoutReferences.
	
	coercionType := leftType arithmeticCoerceWith: rightType.
	coercionType ifNil: [
		message semanticError: 'Cannot perform arithmetic operation {1} with values of types "{2}" and "{3}".'
			format:{ message selector printString . leftType name . rightType name }
	].
	message
		coercionType: coercionType;
		type: coercionType
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkAtomicFetchAndAddMessage: message receiver: receiver [
	| pointerType pointedType value valueType |
	pointerType := receiver type.
	pointerType isPointerType ifFalse: [
		message semanticError: 'Expected a pointer type to perform atomic operation'.
	].

	pointedType := pointerType pointed.
	pointedType readOnly ifTrue: [ 
		message semanticError: 'Modifying a read-only value.'.
	].
	
	pointedType isIntegerType ifFalse: [ 
		message semanticError: 'Atomic operation {1} expects integer values' format: {message selector printString}.
	].

	"Check the value type"
	value := message arguments first.
	self visitNode: value.
	valueType := value type withoutReferences.
	(valueType canBeImplicitlyConvertedTo: pointedType) ifFalse: [
		message semanticError: 'Cannot implicitly convert value of type "{1}" to type "{2}".' format: { valueType name . pointedType }
	].
	
	message type: pointedType.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkAtomicSwapValueMessage: message receiver: receiver [
	| pointerType pointedType value valueType |
	pointerType := receiver type.
	pointerType isPointerType ifFalse: [
		message semanticError: 'Expected a pointer type to perform atomic operation'.
	].

	pointedType := pointerType pointed.
	pointedType readOnly ifTrue: [ 
		message semanticError: 'Modifying a read-only value.'.
	].

	"Check the value type"
	value := message arguments first.
	self visitNode: value.
	valueType := value type withoutReferences.
	(valueType canBeImplicitlyConvertedTo: pointedType) ifFalse: [
		message semanticError: 'Cannot implicitly convert value of type "{1}" to type "{2}".' format: { valueType name . pointedType }
	].
	
	message type: pointedType.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkBinaryBitwiseMessage: message receiver: receiver [
	self checkArithmeticMessage: message receiver: receiver.
	message type isFloatType ifTrue: [
		message error: 'Cannot perform bitwise logical operation with floating point values.'
	].

]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> checkCall: functionType argumentTypes: argumentTypes at: node [
	(argumentTypes size < functionType arguments size or:
	[argumentTypes size > functionType arguments size and: [ functionType variadic not ]]) ifTrue: [ 
		node semanticError: 'Mismatching number of arguments for function of type {1}.' format: { functionType name }.
	].

	"Check the type of the argumetns"
	functionType arguments doWithIndex: [ :expectedType :index |
		(argumentTypes at: index) implicitlyConvertedTo: expectedType at: node.
	].
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkCastToMessage: message receiver: receiver [
	| source sourceType targetType |
	self assert: message arguments size = 1.
	source := receiver.
	sourceType := receiver type withoutReferences.
	targetType := self solveTypeExpression: message arguments first.
	(sourceType canBeExplicitlyConvertedTo: targetType) ifFalse: [
		message semanticError: 'Cannot perform explicit type conversion from {1} to {2}.' format: { sourceType name . targetType name }
	].
	message type: targetType.

]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkComparisonMessage: message receiver: receiver [
	| leftType rightType left right coercionType |
	self assert: message arguments size = 1.
	left := receiver.
	leftType := receiver type withoutReferences.
	
	right := message arguments first.
	self visitNode: right.
	
	rightType := message arguments first type withoutReferences.
	
	coercionType := leftType arithmeticCoerceWith: rightType.
	coercionType ifNil: [
		message semanticError: 'Cannot perform comparison operation {1} with values of types "{2}" and "{3}".'
			format:{ message selector printString . leftType name . rightType name }
	].

	
	message
		coercionType: coercionType;
		setTypeIfNil: ((coercionType isDynamicObjectType and: [(#(== ~~) includes:message selector) not])
			ifTrue: [ compiler objectType ] ifFalse: [ compiler booleanType ])
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkEqualityMessage: message receiver: receiver [
	^ self checkComparisonMessage: message receiver: receiver
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkFirstSlotPointerMessage: message receiver: receiver [
	| source sourceType targetType |
	self assert: message arguments size <= 1.
	source := receiver.
	sourceType := receiver type withoutReferences.
	(sourceType isDynamicObjectType or: [ sourceType isSpecificDynamicObjectType ]) ifFalse: [ 
		message semanticError: 'Receiver must be an object for message {1}.' format: { message selector printString }.
	].

	message arguments size = 1 ifTrue: [ 
		targetType := self solveTypeExpression: message arguments first.
		targetType isPointerType ifFalse: [ 
			message semanticError: 'Target type of message {1} must be a pointer type.' format: { message selector printString }
		]
	] ifFalse: [
		targetType := compiler dynamicObjectType pointer.
	].
	
	message type: targetType
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkIdentityEqualityMessage: message receiver: receiver [
	^ self checkComparisonMessage: message receiver: receiver
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkIfSelectionMessage: message receiver: receiver [
	| firstResultType secondResultType selector receiverType firstType secondType resultType |
	(self isMessageACandidateForInlining: message receiver: receiver) ifFalse: [
		^ self checkNormalMessage: message receiver: receiver
	].

	self assert: message arguments size >= 1.
	self assert: message arguments size <= 2.
	receiverType := receiver type.
	(receiverType isBooleanType and: [(BooleanControlFlowMessages includes: message selector) not]) ifTrue: [ 
		message semanticError: '{1} cannot be send to boolean value.' format: { message selector printString }
	].

	selector := message selector.
	(#(ifNotNil: ifNotNil:ifNil:) includes: selector) ifTrue: [
		self visitInlinedBlock:  message arguments first cullTypes: { receiverType } from: message.
	].
	self visitInlinedBlock: message arguments first.
	firstType := self extractInlinedBlockType: message arguments first.
	firstResultType := (firstType isFunctionType or: [ firstType isBlockType ])
		ifTrue: [ firstType returnType]
		ifFalse: [ compiler objectType ].
	
	secondResultType := compiler nilType.
	(message arguments size = 1 and: [ selector == #ifNil: ]) ifTrue: [ 
		secondResultType := receiverType
	].
	message arguments size = 2 ifTrue: [ 
		secondResultType := compiler objectType.
		(selector == #ifNil:ifNotNil) ifTrue: [ 
			self visitInlinedBlock: message arguments second cullTypes: { receiverType }.
		].
		self visitInlinedBlock: message arguments second.
		secondType := self extractInlinedBlockType: message arguments second.
		secondResultType := secondType isFunctionType
			ifTrue: [ secondType returnType ]
			ifFalse: [ compiler objectType ].
	].
	
	resultType := (firstResultType arithmeticCoerceWith: secondResultType) asValueTypeKeepVoid.
	resultType ifNil: [ 
		self flag: 'TODO: Maybe try to convert to object?'.
		self halt.
	].
	
	message type: resultType.	
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkInvalidMessage: message receiver: receiver [
	| valueType specialType |
	"Try again without the reference type."
	receiver type isReferenceType ifTrue: [ 
		valueType := receiver type withoutReferences.
		specialType := valueType specialMessageTypeForSelector: message selector.
		specialType ~~ #Invalid ifTrue: [ 
			message specialMessageType: specialType.
			^ self checkSpecialMessage: message messageType: message specialMessageType receiver: receiver
		]
		
	].

	"This is an error."
	message semanticError: 'Cannot send special message {1} to object of type {2}.' format: { message selector printString . receiver type name }
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> checkMessage: message receiver: receiver [
	| receiverValueType |
	(compiler isLazySelector: message selector) ifTrue: [ 
		method markLazySelectorPresence
	].
	
	(receiver isBlockNode and: [ (BlockMessages includesKey: message selector) and: [self isMessageACandidateForInlining: message receiver: receiver]]) ifTrue: [ 
		self flag: 'TODO: Support more block special messages'.
		^ self checkWhileLoopMessage: message receiver: receiver
	].

	message compileTimeValue ifNotNil: [ ^ self ].
	message compileTimeMessageLookup ifNotNil: [ ^ self checkMessageWithCompileTimeLookup: message receiver: receiver ].

	receiverValueType := receiver type withoutReferences.
	receiverValueType isCompileTimeType ifTrue: [
		^ self evaluateCompileTimeMessage: message receiver: receiver
	].

	message specialMessageType: (receiver type specialMessageTypeForSelector: message selector environment: environment at: message).
	message specialMessageType ifNil: [ 
		message specialMessageType: (receiverValueType specialMessageTypeForSelector: message selector).
	].

	message specialMessageType ifNotNil: [ ^ self checkSpecialMessage: message messageType: message specialMessageType receiver: receiver ].

	^ self checkNormalMessage: message receiver: receiver
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkMessageWithCompileTimeLookup: message receiver: receiver [
	| function functionType receiverType submittedArguments |
	self assert: message compileTimeMessageLookup isNotNil.
	function := message compileTimeMessageLookup.
	functionType := function type.

	message arguments do: [ :arg | self visitNode: arg ].
	submittedArguments := message arguments collect: #type.
	function receiverType isVoidType ifFalse: [ 
		self halt.
	].

	self checkCall: functionType argumentTypes: submittedArguments at: message.
	message type: functionType returnType.

]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkNormalMessage: message receiver: receiver [
	"Clear the special message type. This means that the message is dispatched as a normal object message."
	| receiverType calledMethodSignature passEverythingAsObjects resultType expectedType |
	message specialMessageType: nil.
	
	receiverType := receiver type withoutReferences.
	
	"Visit the arguments".
	message arguments do: [ :arg |
		self visitNode: arg.
	].

	passEverythingAsObjects := receiverType isAnyDynamicObjectType.
	
	"Find a method that implements this message."
	calledMethodSignature := receiverType methodSignatureForSelector: message selector environment: environment.
	calledMethodSignature ifNotNil: [
		
		"This must be a function type."
		calledMethodSignature isFunctionType ifFalse: [ 
			message semanticError: 'Cannot send message {1} to object of type {2}.' format: { message selector printString . receiverType name }
		].
	
		"Check the arguments"
		message arguments doWithIndex: [ :arg :index |
			expectedType := (calledMethodSignature arguments at: index + 1) solveSpecialTypeWithReceiverNode: receiver type: receiverType environment: environment at: arg.
			arg type implicitlyConvertedTo: expectedType at: arg.
			passEverythingAsObjects ifTrue: [
				arg type implicitlyConvertedTo: compiler objectType at: arg
			].
		].
	
		"Use the correct return type."
		resultType := calledMethodSignature returnType solveSpecialTypeWithReceiverNode: receiver type: receiverType environment: environment at: message.

		"If passing everything as an object, then we should be able to cast object -> into the result type."
		(passEverythingAsObjects and: [ resultType isAnyDynamicObjectType not]) ifTrue: [ 
			(compiler objectType canBeExplicitlyConvertedTo: resultType) ifFalse: [ 
				message semanticError: 'Cannot call non-final method with return type of: {1}' format: { resultType asString }
			]
		].

		message type: resultType.
		^ self
	].
	
	"Is this an ordinary object message send?"
	(receiverType isDynamicObjectType or: [receiverType canBeImplicitlyConvertedTo: compiler objectType ]) ifTrue: [
		message arguments do: [ :arg |
			arg type implicitlyConvertedTo: compiler objectType at: arg
		].
	
		message type: compiler objectType.
		^ self
	].
	
	message semanticError: 'Cannot send message {1} to value of type {2}' format: { message selector printString . receiverType name }
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkNotMessage: message receiver: receiver [
	| receiverValueType |
	receiverValueType := receiver type withoutReferences asValueType.
	
	receiverValueType isBooleanType ifTrue: [ 
		message type: receiverValueType.
		^ self
	].

	^ self checkNormalMessage: message receiver: receiver
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> checkOrMessage: message receiver: receiver [
	| argument blockType blockResultType coercionType |
	self assert: message arguments size = 1.
	argument := message arguments first.
	self visitInlinedBlock: argument types: #() from: message.
	
	blockType := argument type withoutReferences.
	blockResultType := blockType.
	(blockType isFunctionType or: [ blockType isBlockType ]) ifTrue: [ 
		blockResultType := blockType returnType
	].

	coercionType := receiver type arithmeticCoerceWith: blockResultType.
	coercionType ifNil: [ message semanticError: 'Failed to find a proper return type for inlined #or:' ].
	
	message setTypeIfNil: coercionType.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkPointerDeReferenceMessage: message receiver: receiver [
	| receiverType elementType argument |
	receiverType := receiver type withoutReferences.
	message arguments ifNotEmpty: [
		self assert: message arguments size = 1.
		message coercionType: compiler intPointerType.
		argument := message arguments first.
		self visitNode: argument.
		argument type implicitlyConvertedTo: message coercionType at: message arguments first
	].
	
	self assert: (receiverType isPointerType or: [ receiverType isArrayType ]).
	elementType := receiverType isPointerType ifTrue: [ receiverType pointed ] ifFalse: [ receiverType baseType ].
	elementType isVoidType ifTrue: [
		message semanticError: 'Cannot de-reference pointer to void.'
	].

	message type: elementType ref.

	
	
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkPointerElementAssignmentMessage: message receiver: receiver [
	| receiverType elementType index value |
	self assert: message arguments size = 2.
	receiverType := receiver type withoutReferences.
	message coercionType: compiler intPointerType.

	index := message arguments first.
	value := message arguments second.
	
	self visitNode: index.
	self visitNode: value.
	
	index type implicitlyConvertedTo: message coercionType at: index.
	
	self assert: (receiverType isPointerType or: [ receiverType isArrayType ]).
	elementType := receiverType isPointerType ifTrue: [ receiverType pointed ] ifFalse: [ receiverType baseType ].	
	elementType isVoidType ifTrue: [
		message semanticError: 'Cannot assign element through pointer to void..'
	].

	value type implicitlyConvertedTo: elementType at: message.
	message type: elementType ref.

]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkPrivateSlotsMessage: message receiver: receiver [
	message type: (receiver type withoutReferences privateSlotsTypeIn: environment at: message)
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkRangeLoopMessage: message receiver: receiver [
	| start increment body end coercionType blockType startType |
	(self isMessageACandidateForInlining: message receiver: receiver) ifFalse: [
		self halt.
		^ self checkNormalMessage: message receiver: receiver
	].

	start := message receiver.
	startType := start type withoutReferences.
	message type: startType.
	
	end := message arguments first.
	increment := message arguments size = 3 ifTrue: [ message arguments second ] ifFalse: [ nil ].
	body := message arguments last.
	
	self visitNode: end.
	coercionType := startType arithmeticCoerceWith: end type.
	coercionType ifNil: [ ^ self checkNormalMessage: message receiver: receiver ].
	
	increment ifNotNil: [
		self visitNode: increment.
		coercionType := coercionType arithmeticCoerceWith: increment type.
		coercionType ifNil: [ ^ self checkNormalMessage: message receiver: receiver ].
	].

	coercionType := coercionType asValueType.
	self visitInlinedBlock: body types: { coercionType } from: message.
	
	blockType := body type withoutReferences.
	blockType isBlockType ifTrue: [
		blockType := blockType functionType
	].

	blockType isFunctionType ifTrue: [
		(coercionType arithmeticCoerceWith: blockType arguments first) ifNotNil: [ :newCoercionType | coercionType := newCoercionType ].
		coercionType implicitlyConvertedTo: blockType arguments first at: message
	] ifFalse: [ 
		coercionType implicitlyConvertedTo: compiler objectType at: message
	].

	message coercionType: coercionType.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkReinterpretCastToMessage: message receiver: receiver [
	| source sourceType targetType |
	self assert: message arguments size = 1.
	source := receiver.
	sourceType := receiver type withoutReferences.
	targetType := self solveTypeExpression: message arguments first.
	(sourceType canBeReinterpretedTo: targetType) ifFalse: [
		message semanticError: 'Cannot perform reinterpret type conversion from {1} to {2}.' format: { sourceType name . targetType name }
	].
	message type: targetType.

]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkSetSlotMessage: message receiver: receiver [
	| receiverType slot valueType |
	self assert: message arguments size = 1.
	receiverType := receiver type withoutReferences.
	slot := receiverType slotNamed: message selector allButLast.
	
	self visitNode: message arguments first.
	valueType := message arguments first type.
	(valueType canBeImplicitlyConvertedTo: slot type) ifFalse: [ 
		message semanticError: 'Cannot convert implicitly a value of type "{1}" to type "{2}"' format: { valueType name . slot type name }
	].
	
	message type: (slot type ref readOnly: receiverType readOnly)
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkSlotMessage: message receiver: receiver [
	| receiverType slot |
	receiverType := receiver type withoutReferences.
	slot := receiverType slotNamed: message selector.
	message type: (slot type ref readOnly: receiverType readOnly)
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkSpecialMessage: message messageType: specialMessageType receiver: receiver [
	| selector |
	selector := ('check' , specialMessageType , 'Message:receiver:') asSymbol.
	^ self perform: selector with: message with: receiver
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkStructureNewMessage: message receiver: receiver [
	| receiverType structureType |
	receiverType := receiver type withoutReferences.
	self assert: receiverType isMetaType.
	
	structureType := receiverType instanceType.
	message type: structureType
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkTypeSizeQueryMessage: message receiver: receiver [
	| receiverType |
	receiverType := receiver type withoutReferences.
	self assert: receiverType isMetaType.
	message type: compiler uintPointerType
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkUnaryArithmeticMessage: message receiver: receiver [
	| receiverValueType |
	receiverValueType := receiver type withoutReferences asValueType.
	receiverValueType isNumberType ifTrue: [
		(message selector == #sqrt and: [ receiverValueType isIntegerType ]) ifTrue: [
			message type: compiler doubleType
		] ifFalse: [ 
			message type: receiverValueType.
		].
		^ self
	].

	^ self checkNormalMessage: message receiver: receiver 
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkUncheckedFramePointerMessage: message receiver: receiver [
	self assert: message arguments isEmpty.

	message type: compiler voidType pointer.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkUncheckedReplaceContextFunctionMessage: message receiver: receiver [
	| newFunction functionType |
	self assert: message arguments size = 1.
	newFunction := message arguments first.
	self visitNode: newFunction.
	
	functionType := newFunction type withoutReferences.
	functionType isPointerType ifFalse: [ 
		message semanticError: 'Expected any pointer value to replace the function of thisContext.'
	].
	
	message type: compiler voidType.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkUncheckedReturnFromFrameValueMessage: message receiver: receiver [
	| newFramePointer returnValue newFramePointerType exitPoint exitPointType |
	self assert: message arguments size = 3.
	newFramePointer := message arguments first.
	returnValue := message arguments second.
	exitPoint := message arguments third.
	self visitNode: newFramePointer.
	self visitNode: returnValue.
	self visitNode: exitPoint.
	
	newFramePointerType := newFramePointer type withoutReferences.
	newFramePointerType isPointerType ifFalse: [ 
		message semanticError: 'Expected any pointer value to replace frame pointer thisContext.'
	].

	self flag: 'TODO: Add support for restoring the stack pointer.'.
	
	exitPointType := exitPoint type withoutReferences.
	exitPointType isPointerType ifFalse: [ 
		message semanticError: 'Expected any pointer value for the exit point.'
	].
	
	message type: compiler voidType.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkWhileLoopMessage: message receiver: receiver [
	| conditionBlockType conditionType |
	(self isMessageACandidateForInlining: message receiver: receiver) ifFalse: [
		^ self checkNormalMessage: message receiver: receiver
	].

	self assert: message arguments size <= 1.
	
	message specialMessageType: #WhileLoop.
	self visitInlinedBlock: receiver.

	conditionBlockType := self extractInlinedBlockType: receiver.
	conditionBlockType isFunctionType ifTrue: [
		conditionBlockType arguments ifNotEmpty: [
			message semanticError: '{1} sent to block with arguments.' format: { message selector }.
		]
	] ifFalse: [ 
		^ self checkNormalMessage: message receiver: receiver
	].
	
	conditionType := conditionBlockType returnType withoutReferences.
	(conditionType isBooleanType and: [(BooleanControlFlowMessages includes: message selector) not]) ifTrue: [ 
		message semanticError: '{1} cannot be send to boolean value.' format: { message selector printString }
	].

	message arguments ifNotEmpty: [ 
		self visitInlinedBlock: message arguments first.
	].
	message type: compiler nilType.

]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> checkYourselfMessage: message receiver: receiver [
	message type: receiver type.
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> evaluateCompileTimeMessage: message receiver: receiver [
	|evaluator receiverValue superClass |
	evaluator := self asEvaluator.
	receiverValue := evaluator evaluate: receiver.
	receiverValue isNamespace ifTrue: [ 
		(receiverValue concreteMethodForSelector: message selector) ifNotNil: [ :concreteMethod |
			message compileTimeMessageLookup: concreteMethod.
			^ self checkMessage: message receiver: receiver
		].
	
		message selector precedence = 1 ifTrue: [
			^ self setCompileTimeValue: (receiverValue lookSymbol: message selector ifAbsent: [
					message semanticError: 'Namespace {1} does not have member named {2}' format: { receiverValue name . message selector }
			]) in: message.
		].
	
		^ self checkNormalMessage: message receiver: receiver
	].
	superClass := receiver superClassForValue: receiverValue.
	evaluator evaluateMessage: message receiver: receiverValue receiverType: receiver type inSuperclass: superClass.
	
	self assert: message compileTimeValue isNotNil.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> extractInlinedBlockType: node [
	| type |
	type := node type withoutReferences.
	^ type isBlockType
		ifTrue: [ type functionType ]
		ifFalse: [
			(type isPointerType and: [ type pointed isFunctionType ])
			ifTrue: [ type pointed ] ifFalse: [ type ]
		]
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> isMessageACandidateForInlining: message receiver: receiver [
	receiver isSuper ifTrue: [ ^ false ].
	message isCascaded ifTrue: [ ^ false ].
	^ true
]

{ #category : #initialization }
LowtalkMethodSemanticAnalyzer >> setCompileTimeValue: value in: node [
	node compileTimeValue: value.
	node type: value type.
	^ node compileTimeValue
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitArrayLiteralNode: aNode [
	aNode type: self compiler objectType.
	^ aNode value
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitArrayNode: aNode [
	aNode expressionList do: [ :el |
		self visitNode: el.
		(el type canBeImplicitlyConvertedTo: self compiler objectType) ifFalse: [ 
			el semanticError: 'Cannot coerce implicitly object of type {1} to object.' format: { el type name }
		]
	].
	aNode type: self compiler objectType.
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitAssignmentNode: node [
	| referenceType expectedType |
	self visitNode: node value.
	self visitNode: node reference.
	
	referenceType := node reference type.
	referenceType isReferenceType ifFalse: [
		node semanticError: 'Expected a reference to perform assignment instead of value of type {1}.' format: { referenceType name }
	].

	"Make sure the value can be converted to the expected type."
	expectedType := referenceType referenced.
	node value type implicitlyConvertedTo: expectedType at: node.

	"Set the result type."	
	node type: referenceType.

]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitBlockArgumentNode: argumentNode [
	| variable |
	self solveBlockArgumentType: argumentNode.
	
	variable := LowtalkMethodArgument new
		valueType: argumentNode type;
		name: argumentNode name;
		definitionNode: argumentNode;
		method: method;
		isConstant: true.
	environment setSymbol: variable name value: variable ifPresent: [ 
		argumentNode semanticError: 'Argument variable name {1} is already in use.' format: { variable name printString }
	].

	self flag: 'Remove this hack'.
	argumentNode binding ifNil: [ argumentNode binding: variable ].
	^ argumentNode binding
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitBlockNode: node [
	node definition: (self class new analyzeBlock: node environment: environment parentMethod: method).
	
	self flag: 'TODO: Support full block closures for these cases.'.
	node definition receiverType isVoidType ifFalse: [ method markLazySelectorPresence ].
	node definition hasLocalReturns ifTrue: [ method markLazySelectorPresence ].
	^ node definition
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitBooleanLiteralNode: node [
	node type: compiler booleanLiteralType.
	
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitCallExpression: callExpression [
	| receiverType |
	self visitNode: callExpression receiver.
	callExpression arguments do: [ :arg | self visitNode: arg ].
	
	receiverType := callExpression receiver type withoutReferences.
	receiverType isBlockType ifTrue: [ receiverType := receiverType functionType ].
	(receiverType isPointerType and: [ receiverType pointed isFunctionType ]) ifTrue: [ receiverType := receiverType pointed ].
	
	receiverType isFunctionType ifFalse: [
		"Implemented by sending valueWithArguments:types:"
		callExpression type: compiler objectType.
		^ self.
	].

	self checkCall: receiverType argumentTypes: (callExpression arguments collect: #type) at: callExpression.
	callExpression type: receiverType returnType.

]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitCharacterLiteralNode: node [
	node type: compiler characterLiteralType
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitExpressionListNode: list [
	| resultType |
	list pragmaList do: [ :pragma | self visitNode: pragma ].
	list locals do: [ :local | self visitNode: local ].
	
	resultType := compiler objectType.
	list expressions do: [ :node |
		self visitNode: node.
		resultType := node type.
	].

	list type: resultType.
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitFloatLiteralNode: node [
	node type: compiler floatLiteralType
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitIdentifierReferenceNode: identifier [
	| result |
	result := (environment lookSymbolRecursively: identifier value ifAbsent: [
		identifier environment: environment semanticError: 'Undeclared identifier {1}' format: { identifier value }
	]) asLowtalkVariableReferenceFor: self compiler.

	self flag: 'Remove this hack interpreting inlined closures in a proper way'.
	identifier binding ifNil: [
		identifier binding: result.
		
		(result isMethodVariable and: [result isMethodReceiverSlot not]) ifTrue: [
			result method ~~ method ifTrue: [ 
				self captureMethodVariable: result
			]
		].
	].

	self assert: identifier binding class ~~ LowtalkSlotPointer.
	identifier type: result type.
	^ result
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> visitInlinedBlock: node [
	| blockEnvironment argumentTypes actualReturnType functionType |
	node isBlockNode ifFalse: [ ^ self visitNode: node ].
	node inlined: true.
	
	blockEnvironment := LowtalkEnvironment parent: environment.
	node selfType: (self solveTypeExpression: node selfTypeExpression defaultType: compiler voidType).
	self withEnvironment: blockEnvironment do: [ 
		argumentTypes := node arguments collect: [ :arg | (self visitInlinedBlockArgument: arg) type ].
		self visitNode: node body
	].

	actualReturnType := node body type.
	node returnTypeExpression ifNil: [
		actualReturnType isVoidType ifTrue: [ actualReturnType := compiler nilType ].
		node returnType: actualReturnType.
	] ifNotNil: [
		node returnType: (self solveTypeExpression: node returnTypeExpression).
		actualReturnType implicitlyConvertedTo: node returnType at: node.
	].

	functionType := (LowtalkFunctionType target: compiler compilationTarget) arguments: argumentTypes; returnType: node returnType.
	node type: functionType block.
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> visitInlinedBlock: node cullTypes: expectedArgumentTypes from: parentNode [
	| blockType  |
	
	"Try to infer some types in the inline block case"
	node isBlockNode ifTrue: [
		node arguments size > expectedArgumentTypes size ifTrue: [ 
			node semanticError: 'Block containts more arguments than the one that can receive'.
		].
		^ self visitInlinedBlock: node types: (expectedArgumentTypes first: node arguments size) from: parentNode
	].

	"Visit the inlined block"
	self visitInlinedBlock: node.
	
	"Check the called function signature."
	blockType := self extractInlinedBlockType: node.
	blockType isFunctionType ifTrue: [
		blockType arguments size > expectedArgumentTypes size ifTrue: [ 
			node semanticError: 'Function more arguments than the ones that can receive'.
		].
		self checkCall: blockType argumentTypes: (expectedArgumentTypes first: blockType arguments size) at: node
	]
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> visitInlinedBlock: node types: expectedArgumentTypes from: parentNode [
	| blockType knownArguments argument |
	
	"Set some types for type inference"
	node isBlockNode ifTrue: [
		knownArguments := node arguments size min: expectedArgumentTypes size.
		1 to: knownArguments do: [ :index |
			argument := node arguments at: index.
			(argument type isNil and: [argument typeExpression isNil]) ifTrue: [ 
				argument type: (expectedArgumentTypes at: index)
			]
		].
	].

	"Visit the inlined block"
	self visitInlinedBlock: node.
	
	"Check the called function signature."
	blockType := self extractInlinedBlockType: node.
	blockType isFunctionType ifTrue: [
		self checkCall: blockType argumentTypes: expectedArgumentTypes at: parentNode
	]
]

{ #category : #'special messages' }
LowtalkMethodSemanticAnalyzer >> visitInlinedBlockArgument: argumentNode [
	| variable |
	self solveBlockArgumentType: argumentNode.
	
	variable := LowtalkMethodInlineArgument new
		valueType: argumentNode type;
		name: argumentNode name;
		isConstant: true;
		method: method.
	method addTemporary: variable.
		
	environment setSymbol: variable name value: variable ifPresent: [ 
		argumentNode semanticError: 'Argument variable name {1} is already in use.' format: { variable name printString }
	].

	self flag: 'Remove this hack'.
	argumentNode binding ifNil: [ argumentNode binding: variable ].
	^ argumentNode binding
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitIntegerLiteralNode: node [
	node type: compiler integerLiteralType
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitLetExpressionNode: node [
	"Infer the proper type of the let expression."
	| variable |
	node typeExpression ifNotNil: [
		node valueType: (self solveTypeExpression: node typeExpression).
	].

	"Check the node value"
	node initialValue ifNotNil: [
		self visitNode: node initialValue.
		node valueType ifNil: [ node valueType: node initialValue type asValueType ].
		node initialValue type implicitlyConvertedTo: node valueType at: node
	].

	"Create the local variable."
	variable := LowtalkMethodLocalVariable new
		valueType: node valueType;
		name: node identifier;
		method: method;
		isConstant: false.
	environment setSymbol: variable name value: variable ifPresent: [ 
		node semanticError: 'Local variable name {1} is already in use in the current scope.' format: { variable name printString }
	].

	node binding ifNil: [ node binding: variable ].
	method addTemporary: variable.
	node setTypeIfNil: node valueType ref.
	
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitLocalVariableNode: node [
	"Create the local variable."
	| variable |
	node valueType: (self solveTypeExpression: node typeExpression defaultType: compiler objectType).

	variable := LowtalkMethodLocalVariable new
		valueType: node valueType;
		name: node name;
		method: method;
		isConstant: false.
	environment setSymbol: variable name value: variable ifPresent: [ 
		node semanticError: 'Local variable name {1} is already in use in the current scope.' format: { variable name printString }
	].

	node binding ifNil: [ node binding: variable ].
	method addTemporary: variable.
	node setTypeIfNil: node valueType ref.
	
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitMessageChainNode: chain [
	self visitNode: chain receiver.
	chain receiver type isStructureType ifTrue: [
		chain receiver type: chain receiver type ref
	].
	
	chain messages do: [ :message |
		self checkMessage: message receiver: chain receiver.
		chain type: message type
	].
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitMessageNode: message [
	(message receiver isBlockNode and: [ BlockMessages includesKey: message selector ]) ifFalse: [ 
		self visitNode: message receiver.
	].
	
	^ self checkMessage: message receiver: message receiver.
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitMethodExpression: aMethodNode [
	aMethodNode setTypeIfNil: compiler objectType.

]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitNilLiteralNode: node [
	node type: compiler nilType.
	
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitPragmaNode: node [
	"Ignored"
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitReturnNode: node [
	self visitNode: node value.
	node type: node value type.
	node type implicitlyConvertedTo: method returnType at: node value.
	
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitSelfNode: aNode [
	aNode type: (environment receiverTypeOr: compiler voidType).
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitStringLiteralNode: node [
	node type: compiler stringLiteralType
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitSuperNode: aNode [
	aNode type: (environment receiverTypeOr: compiler voidType)
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitSymbolLiteralNode: node [
	node type: compiler symbolLiteralType
]

{ #category : #visiting }
LowtalkMethodSemanticAnalyzer >> visitThisContextNode: aNode [
	aNode type: compiler thisContextType.
]

{ #category : #'as yet unclassified' }
LowtalkMethodSemanticAnalyzer >> withEnvironment: anEnvironment do: aBlock [
	| oldEnvironment |
	oldEnvironment := environment.
	environment := anEnvironment.
	[ 
		aBlock value
	] ensure: [ environment := oldEnvironment ]
]
