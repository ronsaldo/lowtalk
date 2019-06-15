Class {
	#name : #LowtalkCodeGenerator,
	#superclass : #LowtalkASTVisitor,
	#instVars : [
		'compiler',
		'method',
		'allocaBlock',
		'allocaBuilder',
		'bodyBlock',
		'builder',
		'selfType',
		'selfValue',
		'currentFunction',
		'parentCodeGenerator',
		'capturedValueDictionary',
		'capturedValues',
		'currentReturnContext',
		'initializationBuilder',
		'initializationBlock',
		'currentNonLocalReturnMethod'
	],
	#classVars : [
		'BinaryOperationMap',
		'BlockMessages',
		'InlinedThisContextMessages',
		'MessageConditionTypes',
		'PerformSelectors'
	],
	#category : #'Lowtalk-Core-CodeGeneration'
}

{ #category : #initialization }
LowtalkCodeGenerator class >> initialize [
	super initialize.
	
	PerformSelectors := Set newFrom: #(
		#perform:
		#perform:with:
		#perform:with:with:
		#perform:with:with:with:
		#perform:with:with:with:with:
		#perform:with:with:with:with:with:
		#perform:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:with:with:with:with:with:with:with:
		#perform:with:with:with:with:with:with:with:with:with:with:with:with:with:with:with:
	).
	
	BinaryOperationMap := Dictionary newFromPairs: #(
		'uint +' add
		'uint -' sub
		'uint *' mul
		'uint //' udiv
		'uint \\' urem
		'uint %' urem
		
		'uint ==' ieq
		'uint ~~' ine
		'uint =' ieq
		'uint ~=' ine
		'uint <' ult
		'uint <=' ule
		'uint >' ugt
		'uint >=' uge

		'pointer ==' ieq
		'pointer ~~' ine
		'pointer =' ieq
		'pointer ~=' ine
		'pointer <' ult
		'pointer <=' ule
		'pointer >' ugt
		'pointer >=' uge
		
		'int +' add
		'int -' sub
		'int *' mul
		'int //' div
		'int \\' rem
		'int %' rem

		'int ==' ieq
		'int ~~' ine
		'int =' ieq
		'int ~=' ine
		'int <' ilt
		'int <=' ile
		'int >' igt
		'int >=' ige
		
		'uint &' bitand
		'uint bitAnd:' bitand
		'uint |' bitor
		'uint bitOr:' bitor
		'uint ^' bitxor
		'uint bitXor:' bitxor
		'uint <<' shiftleft
		'uint >>' shiftright
		'uint bitRotateLeft:' rotateleft
		'uint bitRotateRight:' rotateright

		'int &' bitand
		'int bitAnd:' bitand
		'int |' bitor
		'int bitOr:' bitor
		'int ^' bitxor
		'int bitXor:' bitxor
		'int <<' shiftleft
		'int >>' shiftrightarithmetic
		'int bitRotateLeft:' rotateleft
		'int bitRotateRight:' rotateright
		
		'object ==' dynObjectIdentityEquals
		'object ~~' dynObjectIdentityNotEquals
		
		'float +' fadd
		'float -' fsub
		'float *' fmul
		'float /' fdiv
		'float \\'frem

		'float =' ufeq
		'float ~=' ufne
		'float <' uflt
		'float <=' ufle
		'float >' ufgt
		'float >=' ufge
				
		'bool =' ieq
		'bool ==' ieq
		'bool ~=' ine
		'bool ~~' ine
	).
	
	MessageConditionTypes := Dictionary newFromPairs: #(
		ifTrue: true
		ifFalse: false
		ifTrue:ifFalse: true
		ifFalse:ifTrue: false

		ifNil: nil
		ifNotNil: 0
		ifNil:ifNotNil: nil
		ifNotNil:ifNil: 0
		
		whileTrue true
		whileFalse false
		whileTrue: true
		whileFalse: false
		whileNil: nil
		whileNotNil: 0
	).
	
	BlockMessages := Dictionary newFromPairs: #(
		whileTrue WhileLoop
		whileTrue: WhileLoop
		whileFalse WhileLoop
		whileFalse: WhileLoop
		whileNotNil: WhileLoop
		whileNil: WhileLoop
	).
	
	InlinedThisContextMessages := Dictionary newFromPairs: #(
		uncheckedReplaceFunctionWith: UncheckedReplaceFunctionWith
		uncheckedFramePointer UncheckedFramePointer
		uncheckedReturnFromFrame:value:exitPoint: UncheckedReturnFromFrameValue
	)
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> allocateTemporary: temp [
	| value debugVar |
	value := allocaBuilder alloca: temp valueType ssaType name: temp name.
	temp ssaValue: value.
	
	builder compilationTarget emittingDebugInformation ifTrue: [
		debugVar := SLVMDebugVariable scope: nil name: temp name.
		value debugInformation: debugVar.
	]
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> captureInClosure: aValue [
	| parentValue capture |
	aValue isFunctionLocalValue ifFalse: [ ^ aValue ].
	aValue function == currentFunction  ifTrue: [ ^ aValue ].
	self assert: parentCodeGenerator isNotNil.
	parentValue := parentCodeGenerator captureInClosure: aValue.
	capturedValueDictionary at: parentValue ifPresent: [ :result | ^ result ].
	
	capture := currentFunction createClosureCaptureOfType: aValue type.

	capturedValueDictionary at: parentValue put: capture.
	capturedValues add: parentValue.
	^ capture
]

{ #category : #visiting }
LowtalkCodeGenerator >> coerceImplicitly: value type: sourceType to: targetType at: node [
	^ sourceType ssaCoerce: value implicitlyTo: targetType with: builder at: node.
]

{ #category : #visiting }
LowtalkCodeGenerator >> coerceVariadicArgument: value type: valueType at: node [
	^ valueType ssaCoerceCVariadic: value with: builder at: node.
]

{ #category : #accessing }
LowtalkCodeGenerator >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkCodeGenerator >> compiler: anObject [
	compiler := anObject
]

{ #category : #messages }
LowtalkCodeGenerator >> convertValue: value type: type toConditionOf: selector at: message [
	| conditionType |
	conditionType := MessageConditionTypes at: selector.
	conditionType = true ifTrue: [ 
		type isBooleanType ifTrue: [ ^ value ].
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: false) ].
		self halt.
	].
	conditionType = false ifTrue: [ 
		type isBooleanType ifTrue: [ ^ builder lnot: value ].
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityEquals: value with: (builder addDynamicLiteral: false) ].
		self halt.
	].
	conditionType = nil ifTrue: [
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityEquals: value with: (builder addDynamicLiteral: nil) ].
		type isPointerType ifTrue: [ ^ builder ieq: value with: (SLVMConstant type: value type value: 0) ].
		self halt.
	].
	conditionType = 0 ifTrue: [
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: nil) ].
		type isPointerType ifTrue: [ ^ builder ine: value with: (SLVMConstant type: value type value: 0) ].
		self halt.
	].

	self halt
]

{ #category : #messages }
LowtalkCodeGenerator >> emitArithmetic: selector left: left right: right type: type at: node [
	type isLiteralType ifTrue: [ 
		^ left perform: selector with: right
	].

	(type isDynamicObjectType and: [(#(== ~~) includes: selector) not]) ifTrue: [ 
		^ self emitDynamicMessage: selector receiver: left arguments: { right } at: node
	].

	^ builder addOperation: (BinaryOperationMap at: type operationSignature, ' ' , selector) left: left right: right
]

{ #category : #messages }
LowtalkCodeGenerator >> emitComparison: selector left: left right: right type: type at: node [
	(type isDynamicObjectType and: [ (#(== ~~) includes: selector) not ]) ifTrue: [ 
		^ self emitDynamicMessage: selector receiver: left arguments: { right } at: node
	].

	^ builder addOperation: (BinaryOperationMap at: type operationSignature, ' ' , selector) left: left right: right
]

{ #category : #messages }
LowtalkCodeGenerator >> emitDynamicMessage: selector receiver: receiver arguments: arguments at: node [
	^ builder send: (builder addDynamicLiteral: selector) returnType: compiler objectType ssaType receiver: receiver arguments: arguments
]

{ #category : #'as yet unclassified' }
LowtalkCodeGenerator >> ensureConditionIsBoolean: condition [
	condition type isBooleanType ifTrue: [ ^ condition ].
	condition type isDynamicObjectType ifTrue: [ 
		^ builder dynObjectIdentityNotEquals: condition with: (builder addDynamicLiteral: false)
	].

	self error: 'Compiler error: invalid condition that is supposed to be convertable into a boolean value.'
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> findCapturedReceiver [
	| position |
	method receiverType isVoidType ifFalse: [ ^ nil ].
	position := method parentMethod.
	[position isNotNil] whileTrue: [ 
		position receiverType isVoidType ifFalse: [
			^ {position receiverType . position receiverSSAValue}
		].
		position := position parentMethod
	].
	^ nil
]

{ #category : #messages }
LowtalkCodeGenerator >> generateAddressMessage: message receiver: receiver receiverType: receiverType [
	^ receiver
]

{ #category : #messages }
LowtalkCodeGenerator >> generateAndMessage: message receiver: receiver receiverType: receiverType [
	| condition block startBlock mergeBlock continueBlock branch continueResult blockType blockResultType conditionResult phi |
	block := message arguments first.
	condition := receiverType ssaConvert: receiver explicitlyTo: compiler booleanType with: builder at: message.
	conditionResult := message type isBooleanType ifTrue: [ condition ] ifFalse: [ receiverType ssaConvert: receiver explicitlyTo: message type with: builder at: message].

	"Get the block type"
	blockType := block type withoutReferences.
	blockResultType := blockType.
	(blockType isFunctionType or: [ blockType isBlockType ]) ifTrue: [ 
		blockResultType := blockType returnType
	].

	startBlock := builder currentBlock.	
	mergeBlock := builder newBasicBlock: #andMerge.
	continueBlock := builder newBasicBlock: #andContinue.
	
	"Perform the branch"
	branch := builder branch: condition ifTrue: continueBlock ifFalse: mergeBlock.
	branch block mergeBlock: mergeBlock.
	
	"Evaluate the inline block"
	builder currentBlock: continueBlock.
	continueResult := self inlineBlock: block arguments: #() types: #().
	blockResultType ~= message type ifTrue: [
		continueResult := blockResultType ssaConvert: continueResult explicitlyTo: message type with: builder at: message
	].
	
	continueBlock := builder currentBlock.
	builder jump: mergeBlock.

	"Continue"	
	builder currentBlock: mergeBlock.
	phi := builder phi: message type ssaType.
	phi
		addValue: conditionResult from: startBlock;
		addValue: continueResult from: continueBlock.
	
	^ phi
]

{ #category : #messages }
LowtalkCodeGenerator >> generateArithmeticMessage: message receiver: receiver receiverType: receiverType [
	| leftValue rightValue coercionType leftType rightType |
	leftType := receiverType.
	leftValue := receiver.
	
	rightType := message arguments first type.
	rightValue := self visitNode: message arguments first.

	coercionType := message coercionType.
	leftValue := self coerceImplicitly: leftValue type: leftType to: coercionType at: message.
	rightValue := self coerceImplicitly: rightValue type: rightType to: coercionType at: message.
	
	^ self emitArithmetic: message selector left: leftValue right: rightValue type: coercionType at: message
]

{ #category : #messages }
LowtalkCodeGenerator >> generateAtomicFetchAndAddMessage: message receiver: receiver receiverType: receiverType [
	| value valueType variablePointer builtInName builtInFunction |
	
	"Fetch the receiver"
	variablePointer := self coerceImplicitly: receiver type: receiverType to: receiverType withoutReferences at: message.

	"Convert the value"
	value := self visitNode: message arguments first.
	valueType := message type.
	value := self coerceImplicitly: value type: message arguments first type to: valueType at: message.
	
	builtInName := message selector = #fetchAndAdd: ifTrue: [ 'atomic.fetch_and_add' ] ifFalse: [ 'atomic.fetch_and_subtract' ].
	builtInFunction := builder builtInFunctionName: builtInName argumentTypes: { variablePointer type . valueType ssaType } returnType: valueType ssaType.
	
	^ builder call: builtInFunction arguments: { variablePointer . value }
]

{ #category : #messages }
LowtalkCodeGenerator >> generateAtomicSwapValueMessage: message receiver: receiver receiverType: receiverType [
	| value valueType variablePointer builtInFunction |
	
	"Fetch the receiver"
	variablePointer := self coerceImplicitly: receiver type: receiverType to: receiverType withoutReferences at: message.

	"Convert the value"
	value := self visitNode: message arguments first.
	valueType := message type.
	value := self coerceImplicitly: value type: message arguments first type to: valueType at: message.
	
	builtInFunction := builder builtInFunctionName: 'atomic.swap_value' argumentTypes: { variablePointer type . valueType ssaType } returnType: valueType ssaType.
	
	^ builder call: builtInFunction arguments: { variablePointer . value }
]

{ #category : #messages }
LowtalkCodeGenerator >> generateBinaryBitwiseMessage: message receiver: receiver receiverType: receiverType [
	^ self generateArithmeticMessage: message receiver: receiver receiverType: receiverType
]

{ #category : #messages }
LowtalkCodeGenerator >> generateCastToMessage: message receiver: receiver receiverType: receiverType [
	^ receiverType ssaConvert: receiver explicitlyTo: message type with: builder at: message
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> generateClosure: node parentCodeGenerator: aParentCodeGenerator [
	| capturedSelf functionType ssaFunction startArgument passedSelfType |
	parentCodeGenerator := aParentCodeGenerator.
	method := node definition.
	passedSelfType := method receiverType.
	capturedSelf := self findCapturedReceiver.
	
	self assert: node type isBlockType.
	functionType := node type functionType.
	
	currentFunction := ssaFunction := SLVMClosureDefinition module: compiler ssaModule functionType: functionType ssaType.
	ssaFunction makePrivate.
	ssaFunction gcStrategy: #lowtalk.
	method definition ssaFunction: ssaFunction.
	
	"Create the builders"
	allocaBuilder := SLVMBuilder on: ssaFunction.
	builder := SLVMBuilder on: ssaFunction.
	builder allocaBuilder: allocaBuilder.
	
	allocaBlock := allocaBuilder newBasicBlock: #entry.
	allocaBuilder currentBlock: allocaBlock.
	
	bodyBlock := builder newBasicBlock: #body.
	builder currentBlock: bodyBlock.
	
	"Create the temporaries."
	startArgument := 0.
	passedSelfType isVoidType ifTrue: [
		capturedSelf ifNotNil: [
			selfType := capturedSelf first.
			selfValue := self captureInClosure: capturedSelf second.
		] ifNil: [ 
			selfType := passedSelfType.
			selfValue := nil
		]
	] ifFalse: [ 
		startArgument := 1.
		selfType := passedSelfType.
		selfValue := ssaFunction arguments first.
		method receiverSSAValue: selfValue.
	].

	method arguments doWithIndex: [ :arg :index |
		| ssaArgument |
		ssaArgument := ssaFunction arguments at: index + startArgument.
		self setupArgument: arg withValue: ssaArgument
	].

	method temporaries do: [ :temp |
		self allocateTemporary: temp
	].

	self flag: 'TODO: Initialize the temporary variables with 0 or nil.'.
	
	self generateFunctionBody: node body.
	
	^ {ssaFunction . capturedValues}
]

{ #category : #messages }
LowtalkCodeGenerator >> generateComparisonMessage: message receiver: receiver receiverType: receiverType [
	| leftValue rightValue coercionType leftType rightType |
	leftValue := receiver.
	leftType := receiverType.
	
	rightValue := self visitNode: message arguments first.
	rightType := message arguments first type.

	coercionType := message coercionType.
	leftValue := self coerceImplicitly: leftValue type: leftType to: coercionType at: message.
	rightValue := self coerceImplicitly: rightValue type: rightType to: coercionType at: message.
	
	^ self emitComparison: message selector left: leftValue right: rightValue type: coercionType at: message
]

{ #category : #messages }
LowtalkCodeGenerator >> generateEqualityMessage: message receiver: receiver receiverType: receiverType [
	^ self generateArithmeticMessage: message receiver: receiver receiverType: receiverType
]

{ #category : #messages }
LowtalkCodeGenerator >> generateFirstSlotPointerMessage: message receiver: receiver receiverType: receiverType [
	"Get the receiver value"
	| receiverValueType receiverValue result resultType expectedResultType |
	receiverValueType := receiverType withoutReferences.
	receiverValue := self coerceImplicitly: receiver type: receiverType to: receiverValueType at: message.
	
	"Get the receiver first field pointer"
	result := builder getReference: receiverValue element: (SLVMConstantValue int: 0).
	resultType := compiler objectType pointer.
	expectedResultType := message type.
	^ resultType ssaConvert: result explicitlyTo: expectedResultType with: builder at: message
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> generateFunction: ssaFunction value: functionValue [
	| node startArgument |
	node := functionValue definition node.
	method := functionValue definition.
	selfType := method receiverType.
	method ssaFunction: ssaFunction.
	currentFunction := ssaFunction.

	"Create the builders"
	allocaBuilder := SLVMBuilder on: ssaFunction.
	builder := SLVMBuilder on: ssaFunction.
	builder allocaBuilder: allocaBuilder.
	
	allocaBlock := allocaBuilder newBasicBlock: #entry.
	allocaBuilder currentBlock: allocaBlock.
	
	bodyBlock := builder newBasicBlock: #body.
	builder currentBlock: bodyBlock.

	"Create the temporaries."
	startArgument := 0.
	selfType isVoidType ifFalse: [ 
		startArgument := 1.
		selfValue := ssaFunction arguments first.
		method receiverSSAValue: selfValue.
		self setupSelfArgument: selfValue.
	].

	method arguments doWithIndex: [ :arg :index |
		| ssaArgument |
		ssaArgument := ssaFunction arguments at: index + startArgument.
		self setupArgument: arg withValue: ssaArgument.
	].

	method temporaries do: [ :temp |
		self allocateTemporary: temp
	].

	self flag: 'TODO: Initialize the temporary variables with 0 or nil.'.
	
	self generateFunctionBody: node body.
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> generateFunctionBody: body [
	| result |
	result := self visitNode: body.
	
	initializationBlock ifNotNil: [ 
		allocaBuilder jump: initializationBlock.
		initializationBuilder jump: bodyBlock
	] ifNil: [ 
		allocaBuilder jump: bodyBlock.
	].
	
	builder isLastTerminator ifFalse: [
		method hasLocalReturns ifTrue: [ 
			self tryToReturnImplicitly: selfValue type: selfType
		] ifFalse: [ 
			self tryToReturnImplicitly: result type: body type
		]

	].

	(method selector isNotNil or:
	[ (method methodClass classBindingWithCompiler: compiler) isNotNil
	or: [ currentFunction dynamicLiterals isNotEmpty ]]) ifTrue: [ 
		currentFunction
			addRequiredDynamicLiteral: method selectorRequiredLiteral;
			addRequiredDynamicLiteral: (method methodClass classBindingWithCompiler: compiler);
			hasSelectorAndClassBinding: true

	].
	
	"Create the function context metadata"
	currentFunction dynamicLiterals do: [ :literal | compiler convertDynamicObjectSSAConstant: literal value ].

]

{ #category : #messages }
LowtalkCodeGenerator >> generateIdentityEqualityMessage: message receiver: receiver receiverType: receiverType [
	^ self generateArithmeticMessage: message receiver: receiver receiverType: receiverType
]

{ #category : #messages }
LowtalkCodeGenerator >> generateIfSelectionMessage: message receiver: receiver receiverType: receiverType [
	| value condition valueType trueBlock mergeBlock falseBlock branch trueResult falseResult coercionType selectionBlock result jumpFromTrue jumpFromFalse |
	coercionType := message type.
	
	value := receiver.
	valueType := receiverType withoutReferences.
	value := self coerceImplicitly: value type: message receiver type to: valueType at: message.
	
	falseResult := nil.
	(message arguments size = 1 and: [coercionType isNilType not]) ifTrue: [ 
		message selector = #ifNil: ifTrue: [
			falseResult := self coerceImplicitly: value type: valueType to: coercionType at: message.
		] ifFalse: [
			falseResult := self coerceImplicitly: nil type: compiler nilType to: coercionType at: message
		]
	].
	condition := self convertValue: value type: valueType toConditionOf: message selector at: message.

	"Create the basic blocks that are required"
	trueBlock := builder newBasicBlock: #ifConditionTrue.
	mergeBlock := builder newBasicBlock: #ifMerge.
	jumpFromFalse := false.
	falseBlock := message arguments size = 2 ifTrue: [ builder newBasicBlock: #ifConditionFalse ] ifFalse: [
			jumpFromFalse := true.
			mergeBlock
	].
	
	"Perform the branch"
	branch := builder branch: condition ifTrue: trueBlock ifFalse: falseBlock.
	branch block mergeBlock: mergeBlock.
	selectionBlock := builder currentBlock.
	
	"Generate the true block."
	builder currentBlock: trueBlock.
	(#(#ifNotNil: #ifNotNil:ifNil:) includes: message selector) ifTrue: [ 
		trueResult := self inlineBlock: message arguments first cull: {value} types: {valueType}
	] ifFalse: [ 
		trueResult := self inlineBlock: message arguments first arguments: #() types: #()
	].

	jumpFromTrue := false.
	builder isLastTerminator ifTrue: [ 
		trueResult := nil.
		trueBlock := nil.
	] ifFalse: [ 
		coercionType isVoidType ifFalse: [
			trueResult := self coerceImplicitly: trueResult type: (self inlinedBlockReturnType: message arguments first) to: coercionType at: message.
		].

		trueBlock := builder currentBlock.
		builder jump: mergeBlock.
		jumpFromTrue := true.
	].

	"Generate the false block"
	message arguments size = 2 ifTrue: [ 
		builder currentBlock: falseBlock.
		(#ifNil:ifNotNil: = message selector) ifTrue: [ 
			falseResult := self inlineBlock: message arguments second cull: {value} types: {valueType}
		] ifFalse: [ 
			falseResult := self inlineBlock: message arguments second arguments: #() types: #()
		].
	
		coercionType isVoidType ifFalse: [
			falseResult := self coerceImplicitly: falseResult type: (self inlinedBlockReturnType: message arguments second) to: coercionType at: message.
		].

		falseBlock := builder currentBlock.
		builder isLastTerminator ifFalse: [
			builder jump: mergeBlock.
			jumpFromFalse := true.
		].
	].
	
	mergeBlock predecessors ifEmpty: [
		builder currentBlock: mergeBlock.
		builder unreachable.
		^ branch block addUnreachableStructuredSuccessors.
	] ifNotEmpty: [
		mergeBlock predecessors size = 1 ifTrue: [
			jumpFromTrue ifTrue: [
				branch block mergeBlock: trueBlock.
			] ifFalse: [
				self assert: jumpFromFalse.
				branch block mergeBlock: falseBlock.
			]
		].
	
		builder currentBlock: mergeBlock.
	].

	"Special values"
	(coercionType isNilType or: [ coercionType isVoidType ]) ifTrue: [ ^ nil ].
	
	"Merge the result"	
	trueResult ifNotNil: [ 
		result := builder phi: coercionType ssaType name: #ifResult.
		trueResult type isVoidType ifFalse: [ result addValue: trueResult from: trueBlock ].
		message arguments = 1 ifTrue: [
			falseResult type isVoidType ifFalse: [ result addValue: falseResult from: selectionBlock ]
		] ifFalse: [
			falseResult type isVoidType ifFalse: [ result addValue: falseResult from: falseBlock ]
		].
		^ result
	] ifNil: [
		^ falseResult
	]

]

{ #category : #messages }
LowtalkCodeGenerator >> generateMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass [
	inSuperClass ifFalse: [ 
		message specialMessageType ifNotNil: [ ^ self generateSpecialMessage: message receiver: receiver receiverType: receiverType ].
	].

	message compileTimeMessageLookup ifNotNil: [ ^ self generateMessageWithCompileTimeLookup: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass ].
	^ self generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass
]

{ #category : #messages }
LowtalkCodeGenerator >> generateMessageWithCompileTimeLookup: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass [
	^ self generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass concreteMethod: message compileTimeMessageLookup

]

{ #category : #messages }
LowtalkCodeGenerator >> generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass [
	| arguments receiverValue instruction receiverValueType concreteMethod |
	receiverValueType := receiverType withoutReferences.
	concreteMethod := receiverValueType concreteMethodForNormalMessageSendWithSelector: message selector inSuperClass: inSuperClass.
	concreteMethod ifNotNil: [
		^ self generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass concreteMethod: concreteMethod
	].

	receiverValue := self coerceImplicitly: receiver type: receiverType to: compiler objectType at: message.
	arguments := message arguments collect: [ :arg |
		self coerceImplicitly: (self visitNode: arg) type: arg type to: compiler objectType at: message
	].

	((PerformSelectors includes: message selector) and: [arguments first type isDynamicObjectType]) ifTrue: [
		instruction := builder send: arguments first returnType: message type ssaType receiver: receiverValue arguments: arguments allButFirst.
	] ifFalse: [ 
		instruction := builder send: (builder addDynamicLiteral: message selector) returnType: message type ssaType receiver: receiverValue arguments: arguments.
	].

	inSuperClass ifTrue: [ instruction setSuperSend ].
	^ instruction
]

{ #category : #messages }
LowtalkCodeGenerator >> generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass concreteMethod: concreteMethod [
	"Get the function"
	| function functionType argumentsBaseIndex arguments argumentValue expectedType |
	functionType := concreteMethod type.
	
	function := concreteMethod asLowtalkObjectInstanceWith: compiler.
	function isCompiledMethodMetaData ifTrue: [ function := function sourceMethod ].
	
	argumentsBaseIndex := 0.
	arguments := #().
	concreteMethod receiverType isVoidType ifFalse: [
		arguments := {self coerceImplicitly: receiver type: receiverType to: concreteMethod receiverType at: message}.
		argumentsBaseIndex := 1.
	].

	"Get the arguments"
	arguments := arguments , (message arguments collectWithIndex: [:arg :index |
		argumentValue := self visitNode: arg.
		expectedType := functionType arguments at: index + argumentsBaseIndex.
		self coerceImplicitly: argumentValue type: arg type to: expectedType at: arg
	]).

	^ builder call: function arguments: arguments
]

{ #category : #messages }
LowtalkCodeGenerator >> generateNotMessage: message receiver: receiver receiverType: receiverType [
	message type isDynamicObjectType ifTrue: [
		^ self emitDynamicMessage: message selector receiver: (self coerceImplicitly: receiver type: receiverType to: compiler objectType at: message) arguments: #() at: message
	].

	receiverType isBooleanLiteralType ifTrue: [ 
		^ self coerceImplicitly: receiver not type: receiverType to: message type at: message
	].

	self assert: receiverType isBooleanType.
	^ builder lnot: receiver
]

{ #category : #messages }
LowtalkCodeGenerator >> generateOrMessage: message receiver: receiver receiverType: receiverType [
	| condition block startBlock mergeBlock continueBlock branch continueResult blockType blockResultType conditionResult phi |
	block := message arguments first.
	condition := receiverType ssaConvert: receiver explicitlyTo: compiler booleanType with: builder at: message.
	conditionResult := message type isBooleanType ifTrue: [ condition ] ifFalse: [ receiverType ssaConvert: receiver explicitlyTo: message type with: builder at: message].

	"Get the block type"
	blockType := block type withoutReferences.
	blockResultType := blockType.
	(blockType isFunctionType or: [ blockType isBlockType ]) ifTrue: [ 
		blockResultType := blockType returnType
	].

	startBlock := builder currentBlock.	
	mergeBlock := builder newBasicBlock: #orMerge.
	continueBlock := builder newBasicBlock: #orContinue.
	
	"Perform the branch"
	branch := builder branch: condition ifTrue: mergeBlock ifFalse: continueBlock.
	branch block mergeBlock: mergeBlock.
	
	"Evaluate the inline block"
	builder currentBlock: continueBlock.
	continueResult := self inlineBlock: block arguments: #() types: #().
	blockResultType ~= message type ifTrue: [
		continueResult := blockResultType ssaConvert: continueResult explicitlyTo: message type with: builder at: message
	].
	
	continueBlock := builder currentBlock.
	builder jump: mergeBlock.

	"Continue"	
	builder currentBlock: mergeBlock.
	phi := builder phi: message type ssaType.
	phi
		addValue: conditionResult from: startBlock;
		addValue: continueResult from: continueBlock.
	
	^ phi
]

{ #category : #messages }
LowtalkCodeGenerator >> generatePointerDeReferenceMessage: message receiver: receiver receiverType: receiverType [
	| pointer argument index indexType pointerType |
	pointer := receiver.
	pointerType := receiverType withoutReferences.
	self assert: (pointerType isPointerType or: [pointerType isArrayType]).
	
	pointer := self coerceImplicitly: pointer type: receiverType to: pointerType at: message.
	
	message arguments ifNotEmpty: [ 
		self assert: message arguments size = 1.
		argument := message arguments first.
		index := self visitNode: argument.
		indexType := argument type.
		index := self coerceImplicitly: index type: indexType to: message coercionType at: message.
		
		"One vs zero based indices"
		(#(at: basicAt:) includes: message selector) ifTrue: [
			index := builder sub: index with: (SLVMConstant type: message coercionType ssaType value: 1)
		].
	
		^ pointerType isArrayType
			ifTrue: [ builder getPointer: pointer element: {builder constInt: 0 . index} ]
			ifFalse: [ builder getPointer: pointer element: {index} ]
	].

	^ pointer
]

{ #category : #messages }
LowtalkCodeGenerator >> generatePointerElementAssignmentMessage: message receiver: receiver receiverType: receiverType [
	| pointer index pointerType indexNode elementPointer elementType valueNode value |
	pointer := receiver.
	pointerType := receiverType withoutReferences.
	self assert: (pointerType isPointerType or: [pointerType isArrayType]).
	
	pointer := self coerceImplicitly: pointer type: receiverType to: pointerType at: message.
	self assert: message arguments size = 2.

	indexNode := message arguments first.
	index := self visitNode: indexNode.
	index := self coerceImplicitly: index type: indexNode type to: message coercionType at: message.
		
	"One vs zero based indices"
	(#(at:put: basicAt:put:) includes: message selector) ifTrue: [
		index := builder sub: index with: (SLVMConstant type: message coercionType ssaType value: 1)
	].

	elementPointer := pointerType isArrayType
			ifTrue: [ builder getPointer: pointer element: {builder constInt: 0 . index} ]
			ifFalse: [ builder getPointer: pointer element: {index} ].
	
	elementType := pointerType isArrayType ifTrue: [ pointerType baseType ] ifFalse: [ pointerType pointed ].
	
	valueNode := message arguments second.
	value := self visitNode: valueNode.
	value := self coerceImplicitly: value type: valueNode type to: elementType at: valueNode.

	self store: value in: elementPointer.
	^ elementPointer
]

{ #category : #messages }
LowtalkCodeGenerator >> generatePrivateSlotsMessage: message receiver: receiver receiverType: receiverType [
	^ self coerceImplicitly: receiver type: receiverType to: receiverType withoutReferences at: message
]

{ #category : #messages }
LowtalkCodeGenerator >> generateRangeLoopMessage: message receiver: receiver receiverType: receiverType [
	| startValue startType coercionType startCoercedValue increment incrementValue stop stopValue loopVariable loopHeader loopBody loopMerge iterationValue condition branch positiveIncrement positiveComparisonBlock negativeComparisonBlock incrementComparisonMerge incrementSignBranch positiveComparisonResult negativeComparisonResult |
	startType := receiverType withoutReferences.
	startValue := self coerceImplicitly: receiver type: receiverType to: startType at: message.
	
	coercionType := message coercionType.
	startCoercedValue := self coerceImplicitly: startValue type: startType to: coercionType at: message.
	
	stop := message arguments first.
	stopValue := self coerceImplicitly: (self visitNode: stop) type: stop type to: coercionType at: message.

	message arguments size = 3 ifTrue: [ 
		increment := message arguments second.
		incrementValue := self coerceImplicitly: (self visitNode: increment) type: increment type to: coercionType at: message.
	] ifFalse: [
		incrementValue := self coerceImplicitly: 1 type: compiler integerLiteralType to: coercionType at: message.
	].

	loopVariable := allocaBuilder alloca: coercionType ssaType.
	self store: startCoercedValue in: loopVariable.
	
	"The loop blocks"
	loopHeader := builder newBasicBlock: #toDoCondition.
	loopBody := builder newBasicBlock: #toDoBody.
	loopMerge := builder newBasicBlock: #toDoMerge.
	
	"Enter into the loop."
	builder jump: loopHeader.
	builder currentBlock: loopHeader.
	iterationValue := builder load: loopVariable.
	incrementValue isConstantValue ifTrue: [ 
		incrementValue value = 0 ifTrue: [ message semanticError: '#to:do:by increment cannot be zero.' ].
		incrementValue value < 0 ifTrue: [ 
			condition := self emitComparison: #>= left: iterationValue right: stopValue type: coercionType at: message.	
		] ifFalse: [ 
			condition := self emitComparison: #<= left: iterationValue right: stopValue type: coercionType at: message.	
		].
		condition := self ensureConditionIsBoolean: condition
	] ifFalse: [
		"Check the increment sign"
		positiveIncrement := self emitComparison: #>= left: incrementValue right: (self coerceImplicitly: 0 type: compiler integerLiteralType to: coercionType at: message) type: coercionType at: message.
		positiveComparisonBlock := builder newBasicBlock: #positiveIncrementComparison.
		negativeComparisonBlock := builder newBasicBlock: #negativeIncrementComparison.
		incrementComparisonMerge := builder newBasicBlock: #incrementComparisonMerge.
		incrementSignBranch := builder branch: positiveIncrement ifTrue: positiveComparisonBlock ifFalse: negativeComparisonBlock.
		loopHeader mergeBlock: incrementComparisonMerge.
		
		"Positive increment"
		builder currentBlock: positiveComparisonBlock.
		positiveComparisonResult := self emitComparison: #<= left: iterationValue right: stopValue type: coercionType at: message.
		positiveComparisonResult := self ensureConditionIsBoolean: positiveComparisonResult.
		builder jump: incrementComparisonMerge.
		
		"Negative increment"
		builder currentBlock: negativeComparisonBlock.
		negativeComparisonResult := self emitComparison: #>= left: iterationValue right: stopValue type: coercionType at: message.
		negativeComparisonResult := self ensureConditionIsBoolean: negativeComparisonResult.
		builder jump: negativeComparisonResult.
		
		builder currentBlock: incrementComparisonMerge.
		condition := builder phi: builder boolType.
		condition
			addValue: positiveComparisonResult from: positiveComparisonBlock;
			addValue: negativeComparisonResult from: negativeComparisonBlock.
	].
	
	branch := builder branch: condition ifTrue: loopBody ifFalse: loopMerge.
	
	"Emit the body"
	builder currentBlock: loopBody.
	iterationValue := builder load: loopVariable.
	self inlineBlock: message arguments last arguments:  {iterationValue} types: { coercionType }.
	
	"Increment"
	builder isLastTerminator ifFalse: [
		iterationValue := builder load: loopVariable.
		self store: (self emitArithmetic: #+ left: iterationValue right: incrementValue type: coercionType at: message) in: loopVariable.
		builder jump: loopHeader
	].

	"Merge"
	builder currentBlock: loopMerge.
		
	^ startValue

]

{ #category : #messages }
LowtalkCodeGenerator >> generateReinterpretCastToMessage: message receiver: receiver receiverType: receiverType [
	| receiverValue |
	receiverValue := self coerceImplicitly: receiver type: receiverType to: receiverType withoutReferences at: message.
	^ builder bitCast: receiverValue target: message type ssaType
]

{ #category : #messages }
LowtalkCodeGenerator >> generateSetSlotMessage: message receiver: receiver receiverType: receiverType [
	| referenceType objectType slot objectPointer slotPointer newValue newValueType |
	self assert: message arguments size = 1.
	objectPointer := receiver.
	referenceType := receiverType.
	objectType := referenceType withoutReferences.
	
	"Make sure we have a pointer to the structure."
	self assert: (objectType isStructureType or: [objectType isObjectSlots]).
	(objectType isStructureType and: [referenceType isReferenceType not]) ifTrue: [
		self assert: referenceType isStructureType.
		objectPointer := allocaBuilder alloca: objectType ssaType.
		self store: receiver in: objectPointer
	].
	
	"Get the slot pointer"
	slot := objectType slotNamed: message selector allButLast.
	
	"Convert the slot value"
	newValue := self visitNode: message arguments first.
	newValueType := message arguments first type.
	newValue := self coerceImplicitly: newValue type: newValueType to: slot type at: message.

	"Set the slot value"	
	slotPointer := slot emitSSASlotReferenceOf: objectPointer builder: builder at: message.
	self store: newValue in: slotPointer.
	
	"Return the slot pointer"
	^ slotPointer
]

{ #category : #messages }
LowtalkCodeGenerator >> generateSlotMessage: message receiver: receiver receiverType: receiverType [
	| referenceType objectType slot objectPointer |
	objectPointer := receiver.
	referenceType := receiverType.
	objectType := referenceType withoutReferences.
	
	"Make sure we have a pointer to the pointer instead of a value."
	self assert: (objectType isStructureType or: [objectType isObjectSlots]).
	(objectType isStructureType and: [referenceType isReferenceType not]) ifTrue: [
		self assert: referenceType isStructureType.
		objectPointer := allocaBuilder alloca: objectType ssaType.
		self store: receiver in: objectPointer
	].
	
	slot := objectType slotNamed: message selector.
	^ slot emitSSASlotReferenceOf: objectPointer builder: builder at: message
]

{ #category : #messages }
LowtalkCodeGenerator >> generateSpecialMessage: message receiver: receiver receiverType: receiverType [
	| selector |
	selector := ('generate' , message specialMessageType, 'Message:receiver:receiverType:') asSymbol.
	^ self perform: selector with: message with: receiver with: receiverType
]

{ #category : #messages }
LowtalkCodeGenerator >> generateStructureNewMessage: message receiver: receiver receiverType: receiverType [
	| structureType structureVariable structureValue |
	structureType := receiverType withoutReferences.
	self assert: structureType isMetaType.
	structureType := structureType instanceType.
	self assert: structureType isStructureType.
	
	structureValue := structureType defaultSSAValueWith: builder.
	
	^ message type isReferenceType ifTrue: [ 
		structureVariable := allocaBuilder alloca: structureType ssaType.
		builder store: structureValue in: structureVariable.
		structureVariable
	] ifFalse: [
		structureValue
	]
]

{ #category : #messages }
LowtalkCodeGenerator >> generateTypeSizeQueryMessage: message receiver: receiver receiverType: receiverType [
	| queriedType resultValue |
	self assert: message arguments isEmpty.
	
	queriedType := receiverType withoutReferences.
	self assert: queriedType isMetaType.
	queriedType := queriedType instanceType.
	resultValue := queriedType perform: message selector.
	^ message type convertValue: resultValue toSSAConstantWith: compiler
]

{ #category : #messages }
LowtalkCodeGenerator >> generateUnaryArithmeticMessage: message receiver: receiver receiverType: receiverType [
	| coercedValue |
	message type isDynamicObjectType ifTrue: [
		^ self emitDynamicMessage: message selector receiver: (self coerceImplicitly: receiver type: receiverType to: compiler objectType at: message) arguments: #() at: message
	].

	coercedValue := self coerceImplicitly: receiver type: receiverType to: message type at: message.
	message selector == #negated ifTrue: [
		message type isFloatType ifTrue: [
			^ builder fneg: coercedValue
		] ifFalse: [
			self assert: message type isIntegerType.
			^ builder neg: coercedValue
		]
	].
	message selector == #sqrt ifTrue: [
		self assert: message type isFloatType.
		^ builder fsqrt: coercedValue
	].
	
	self error: 'Unsupported inline unary message.'
]

{ #category : #messages }
LowtalkCodeGenerator >> generateUncheckedFramePointerMessage: message [
	self assert: message arguments isEmpty.
	^ builder getFramePointer
]

{ #category : #messages }
LowtalkCodeGenerator >> generateUncheckedReplaceFunctionWithMessage: message [
	| newFunction argument builtInFunction |
	self assert: message arguments size = 1.
	argument := message arguments first.
	newFunction := self visitNode: argument.
	newFunction := self coerceImplicitly: newFunction type: argument type to: argument type withoutReferences at: message.
	
	builtInFunction := builder builtInFunctionName: 'context.replace_function' argumentTypes: { newFunction type } returnType: compiler voidType ssaType.
	builder
		call: builtInFunction arguments: { newFunction };
		unreachable
]

{ #category : #messages }
LowtalkCodeGenerator >> generateUncheckedReturnFromFrameValueMessage: message [
	|  newFramePointerNode newFramePointer returnValueNode returnValue exitPointNode exitPoint builtInFunction |
	self assert: message arguments size = 3.

	newFramePointerNode := message arguments first.
	newFramePointer := self visitNode: newFramePointerNode.
	newFramePointer := self coerceImplicitly: newFramePointer type: newFramePointerNode type to: newFramePointerNode type withoutReferences at: newFramePointerNode.

	returnValueNode := message arguments second.
	returnValue := self visitNode: returnValueNode.
	returnValue := self coerceImplicitly: returnValue type: returnValueNode type to: returnValueNode type withoutReferences at: returnValueNode.

	exitPointNode := message arguments third.
	exitPoint := self visitNode: exitPointNode.
	exitPoint := self coerceImplicitly: exitPoint type: exitPointNode type to: exitPointNode type withoutReferences at: exitPointNode.
	
	builtInFunction := builder builtInFunctionName: 'context.return_from_frame_value'
		argumentTypes: { newFramePointer type . exitPoint type . returnValue type } returnType: compiler voidType ssaType.
	builder
		call: builtInFunction arguments: { newFramePointer . exitPoint . returnValue };
		unreachable
]

{ #category : #messages }
LowtalkCodeGenerator >> generateWhileLoopMessage: message [
	| loopHeader loopBody loopMerge condition conditionBlockType conditionType branch |
	self assert: message type isNilType.
	
	loopHeader := builder newBasicBlock: #loopHeader.
	loopBody := builder newBasicBlock: #loopBody.
	loopMerge := builder newBasicBlock: #loopMerge.
	
	"Enter into the loop"
	builder jump: loopHeader.
	builder currentBlock: loopHeader.
	
	"Evaluate the condition"
	condition := self inlineBlock: message receiver arguments: #() types: #().
	builder isLastTerminator ifTrue: [ ^ nil ].
	
	conditionBlockType := message receiver type withoutReferences.
	conditionType := conditionBlockType functionType returnType.
	conditionType isReferenceType ifTrue: [ 
		condition := self coerceImplicitly: condition type: conditionType to: conditionType withoutReferences at: message.
		conditionType := conditionType withoutReferences
	].

	condition := self convertValue: condition type: conditionType toConditionOf: message selector at: message.

	branch := builder branch: condition ifTrue: loopBody ifFalse: loopMerge.
	loopHeader
		continueBlock: loopHeader;
		mergeBlock: loopMerge.
		
	"Emit the loop body"
	builder currentBlock: loopBody.
	message arguments ifNotEmpty: [ 
		self inlineBlock: message arguments first arguments: #() types: #()
	].
	
	builder isLastTerminator ifFalse: [ 
		builder jump: loopHeader.
	].

	"End the loop"
	builder currentBlock: loopMerge.
	
	^ nil
]

{ #category : #messages }
LowtalkCodeGenerator >> generateYourselfMessage: message receiver: receiver receiverType: receiverType [
	^ receiver	
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> getCurrentNonLocalReturnMethod [
	currentNonLocalReturnMethod ifNotNil: [ ^ currentNonLocalReturnMethod ].
	(parentCodeGenerator isNil or: [method hasLocalReturns]) ifTrue: [
		currentNonLocalReturnMethod := method
	] ifFalse: [ 
		currentNonLocalReturnMethod := parentCodeGenerator getCurrentNonLocalReturnMethod.
	].

	^ currentNonLocalReturnMethod
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> getCurrentReturnContext [
	currentReturnContext ifNotNil: [ ^ currentReturnContext ].
	(parentCodeGenerator isNil or: [method hasLocalReturns]) ifTrue: [
		currentReturnContext := self initializationBuilder getThisContext
	] ifFalse: [ 
		currentReturnContext := self captureInClosure: parentCodeGenerator getCurrentReturnContext.
	].

	^ currentReturnContext
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> initializationBuilder [
	initializationBuilder ifNotNil: [ ^ initializationBuilder ].
	
	initializationBuilder := SLVMBuilder on: currentFunction .
	initializationBlock := allocaBuilder newBasicBlock: #initialization.
	initializationBuilder currentBlock: initializationBlock.
	
	^ initializationBuilder

]

{ #category : #initialization }
LowtalkCodeGenerator >> initialize [
	super initialize.
	
	capturedValueDictionary := IdentityDictionary new.
	capturedValues := OrderedCollection new.
]

{ #category : #messages }
LowtalkCodeGenerator >> inlineBlock: node arguments: arguments types: argumentTypes [
	| expectedArguments binding |
	expectedArguments := node arguments.
	node arguments doWithIndex: [ :argument :index |
		binding := argument binding.
		binding ssaValue: (self coerceImplicitly: (arguments at: index) type: (argumentTypes at: index) to: binding type at: node).
	].

	^ self visitNode: node body
]

{ #category : #messages }
LowtalkCodeGenerator >> inlineBlock: node cull: arguments types: argumentTypes [
	| usedArguments |
	usedArguments := node arguments size.
	self assert: usedArguments <= arguments size.
	
	^ self inlineBlock: node arguments: (arguments first: usedArguments) types: (argumentTypes first: usedArguments)
]

{ #category : #messages }
LowtalkCodeGenerator >> inlinedBlockReturnType: node [
	| type |
	type := node type withoutReferences.
	^ type isBlockType ifTrue: [ type functionType returnType ] ifFalse: [ compiler objectType ]
]

{ #category : #accessing }
LowtalkCodeGenerator >> method [
	^ method
]

{ #category : #instructions }
LowtalkCodeGenerator >> returnReceiver [
	self halt
]

{ #category : #accessing }
LowtalkCodeGenerator >> selfValue [
	^ selfValue
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> setupArgument: arg withValue: value [
	| debugVar |
	value name: arg name.
	arg ssaValue: value.
	
	builder compilationTarget emittingDebugInformation ifTrue: [
		debugVar := SLVMDebugVariable scope: nil name: arg name.
		value debugInformation: debugVar.
	]
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> setupSelfArgument: arg [
	| debugVar |
	arg name: #self; makeReceiver.
	
	
	builder compilationTarget emittingDebugInformation ifTrue: [
		debugVar := SLVMDebugVariable scope: nil name: arg name.
		arg debugInformation: debugVar.
	]
]

{ #category : #visiting }
LowtalkCodeGenerator >> store: value in: pointer [
	"| barrier |
	value type isDynamicObjectType ifTrue: [
		barrier := compiler ssaWriteBarrier.
		barrier ifNotNil: [
			^ builder call: barrier arguments: { value . pointer }
		].
	]."

	builder store: value in: pointer
]

{ #category : #'top level entry points' }
LowtalkCodeGenerator >> tryToReturnImplicitly: value type: valueType [
	| returnType |
	returnType := method returnType.
	returnType isVoidType ifTrue: [ ^ builder returnVoid ].
	
	(valueType canBeImplicitlyConvertedTo: returnType) ifFalse: [
		method node semanticError: 'Cannot convert implicitly value of type {1} into type {2} for returning.' format: { valueType name . returnType name }
	].

	^ builder return: (self coerceImplicitly: value type: valueType to: method returnType at: method node)

	
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitArrayLiteralNode: aNode [
	^ builder addDynamicLiteral: aNode value
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitArrayNode: aNode [
	| arrayClass arraySize arrayObject value elementPointer |
	self assert: aNode type isDynamicObjectType.

	"Create the array object"
	arrayClass := builder addDynamicLiteral: compiler objectModel arrayClass.
	arraySize := aNode expressionList size.
	arrayObject := builder send: (builder addDynamicLiteral: #basicNew:)
		returnType: compiler objectType ssaType
		receiver: arrayClass arguments: { builder addDynamicLiteral: arraySize }.
		
	"Set the array elements"
	aNode expressionList doWithIndex: [ :valueExpression :index |
		value := self coerceImplicitly: (self visitNode: valueExpression) type: valueExpression type to: compiler objectType at: valueExpression.
		elementPointer := builder getReference: arrayObject element: (builder constInt: index - 1).
		builder store: value in: elementPointer
	].

	^ arrayObject
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitAssignmentNode: assignmentNode [
	| value valueType reference referenceType expectedType convertedValue |
	value := self visitNode: assignmentNode value.
	valueType := assignmentNode value type.
	
	reference := self visitNode: assignmentNode reference.
	referenceType := assignmentNode reference type.
	
	expectedType := referenceType withoutReferences.
	convertedValue := self coerceImplicitly: value type: valueType to: expectedType at:  assignmentNode.
	
	self store: convertedValue in: reference.

	^ reference
	
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitBlockNode: aNode [
	| definitionAndCaptures definition captures |
	definitionAndCaptures := LowtalkCodeGenerator new compiler: compiler;
		generateClosure: aNode parentCodeGenerator: self.
		
	definition := definitionAndCaptures first.
	captures := definitionAndCaptures second.
	aNode type isBlockType ifTrue: [
		^ builder instantiateClosure: definition captures: captures
	].

	self halt.
	^ builder addDynamicLiteral: nil
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitBooleanLiteralNode: node [
	^ node value
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitCallExpression: callExpression [
	| receiver arguments argumentValue expectedType receiverType |
	receiverType := callExpression receiver type withoutReferences.

	(receiverType isFunctionType or:
	[ receiverType isBlockType or:
	[(receiverType isPointerType and: [ receiverType pointed isFunctionType ])]]) ifFalse: [
		self halt.
	].

	"Get the receiver"
	receiver := self visitNode: callExpression receiver.
	receiver := self coerceImplicitly: receiver type: callExpression receiver type to: receiverType at: callExpression.
	(receiver isFunction and: [ receiverType isBlockType ]) ifTrue: [ 
		receiverType := receiverType functionType
	].
	(receiverType isPointerType and: [ receiverType pointed isFunctionType ]) ifTrue: [ 
		receiverType := receiverType pointed
	].
	
	"Get the arguments"
	arguments := callExpression arguments collectWithIndex: [:arg :index |
		argumentValue := self visitNode: arg.
		index <= receiverType arguments size ifTrue: [
			expectedType := receiverType arguments at: index.
			self coerceImplicitly: argumentValue type: arg type to: expectedType at: callExpression
		] ifFalse: [
			self coerceVariadicArgument: argumentValue type: arg type at: arg
		]
	].

	"Generate the call"
	receiverType isBlockType ifTrue: [ 
		self halt.
	].
	^ builder call: receiver arguments: arguments
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitCharacterLiteralNode: node [
	^ node value
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitExpressionListNode: list [
	| result |
	result := nil.
	list expressions do: [ :node |
		builder isLastTerminator ifFalse: [ 
			result := self visitNode: node.
		]
	].

	(result isNil and: [list type isDynamicObjectType]) ifTrue: [ 
		result := builder addDynamicLiteral: nil
	].

	^ result
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitFloatLiteralNode: aNode [
	^ aNode value
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitIdentifierReferenceNode: node [
	| binding |
	binding := node binding.
	node type isCompileTimeType ifTrue: [ 
		^ binding emitSSAVariableCompileTimeValueWith: self builder: builder at: node
	].

	node type isReferenceType ifTrue: [ 
		^ binding emitSSAVariableReferenceWith: self builder: builder at: node
	] ifFalse: [ 
		^ binding emitSSAVariableLoadWith: self builder: builder at: node
	].

	binding isVariable ifTrue: [
		binding isCompileTimeVariable ifTrue: [
			node type isReferenceType ifTrue: [ 
				^ compiler convertCapturedCompileTimeVariable: binding
			] ifFalse: [ 
				^ compiler convertDynamicObjectSSAConstant: binding value.
			].
		].
	
		binding isMethodReceiverSlot ifTrue: [
			^ builder getReference: selfValue element: (SLVMConstantValue int: binding description index)
		].
	
		node binding isMethodVariable ifTrue: [ 
			self assert: node binding method isNotNil.
			self assert: node binding ssaValue isNotNil.
			node binding method ~~ method ifTrue: [ 
				^ self captureInClosure: node binding ssaValue
			].
		].
		^ node binding ssaValue
	].
	binding isNamespace ifTrue: [ 
		node type isCompileTimeType ifTrue: [ ^ binding ].
	].
	self halt.
	
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitIntegerLiteralNode: node [
	^ node value
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitLetExpressionNode: node [
	| initialValue |
	node initialValue ifNotNil: [
		initialValue := self visitNode: node initialValue.
		initialValue := self coerceImplicitly: initialValue type: node initialValue type to: node valueType at: node.
		self store: initialValue in: node binding ssaValue
	].

	^ node binding ssaValue
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitMessageChainNode: chain [
	| receiver receiverType result isSuper temp |
	receiver := self visitNode: chain receiver.
	receiverType := chain receiver type.
	
	(receiverType isReferenceType and: [receiver type isPointerType not]) ifTrue: [
		temp := allocaBuilder alloca: receiver type.
		builder store: receiver in: temp.
		receiver := temp
	].

	result := receiver.
	isSuper := chain receiver isSuper.
	chain messages do: [ :message |
		result := self generateMessage: message receiver: receiver receiverType: receiverType inSuperClass: isSuper
	].

	^ result
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitMessageNode: message [
	| receiver receiverType |
	message compileTimeValue ifNotNil: [ ^ message compileTimeValue ssaValue ].
	message specialMessageType ifNotNil: [
		BlockMessages at: message selector ifPresent: [ :specialType |
			^ self perform: ('generate' , specialType, 'Message:') asSymbol with: message
		].
		message receiver isThisContext ifTrue: [ 
			InlinedThisContextMessages at: message selector ifPresent: [ :specialType |
				^ self perform: ('generate' , specialType, 'Message:') asSymbol with: message
			]
		]
	].

	receiver := self visitNode: message receiver.
	receiverType := message receiver type.
	^ self generateMessage: message receiver: receiver receiverType: receiverType inSuperClass: message receiver isSuper
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitNilLiteralNode: node [
	^ nil
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitNode: node [
	"Keep track of the debug position"
	| debugPosition result |
	builder compilationTarget emittingDebugInformation ifTrue: [
		debugPosition := compiler convertDebugPosition: node position.
		builder pushDebugSourcePosition: debugPosition.
		allocaBuilder pushDebugSourcePosition: debugPosition.
		
		[
			result := super visitNode: node.
		] ensure: [
			builder popDebugSourcePosition.
			allocaBuilder popDebugSourcePosition.
		].
	
		^ result
	].

	^ super visitNode: node

]

{ #category : #visiting }
LowtalkCodeGenerator >> visitReturnNode: node [
	| value valueType returnContext nonLocalReturnMethod |
	value := self visitNode: node value.
	valueType := node value type.
	
	method hasLocalReturns ifFalse: [
		returnContext := self getCurrentReturnContext.
		nonLocalReturnMethod := self getCurrentNonLocalReturnMethod.
		nonLocalReturnMethod ~~ method ifTrue: [
			nonLocalReturnMethod returnType isVoidType ifTrue: [ 
				^ builder returnVoidFromContext: returnContext
			] ifFalse: [ 
				value := self coerceImplicitly: value type: valueType to: nonLocalReturnMethod returnType at: node.
				^ builder return: value fromContext: returnContext
			]
		]
	].

	method returnType isVoidType ifTrue: [
		^ builder returnVoid
	] ifFalse: [
		value := self coerceImplicitly: value type: valueType to: method returnType at: node.
		^ builder return: value 
	]

]

{ #category : #visiting }
LowtalkCodeGenerator >> visitSelfNode: node [
	selfType isVoidType ifTrue: [ ^ nil ].
	^ selfValue
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitStringLiteralNode: node [
	^ node value
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitSuperNode: node [
	selfType isVoidType ifTrue: [ ^ nil ].
	^ selfValue
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitSymbolLiteralNode: aNode [
	^ aNode value
]

{ #category : #visiting }
LowtalkCodeGenerator >> visitThisContextNode: aNode [
	^ builder getThisContext
]
