Class {
	#name : #LowtalkInterpreterMethod,
	#superclass : #LowtalkBObject,
	#instVars : [
		'node',
		'environment',
		'arguments',
		'temporaries',
		'returnType',
		'receiverType',
		'parentMethod',
		'hasLocalReturns',
		'selector',
		'type',
		'receiverSSAValue',
		'ssaFunction',
		'publicSymbol',
		'unmangledName',
		'primitive',
		'hasLazySelector',
		'bytecodeMethods',
		'capturedVariable',
		'outerClosureVariables',
		'inlineMode',
		'pragmas'
	],
	#category : #'Lowtalk-Core-Interpreter'
}

{ #category : #initialization }
LowtalkInterpreterMethod >> addCapturedVariable: aVariable [
	capturedVariable add: aVariable
	
]

{ #category : #initialization }
LowtalkInterpreterMethod >> addOuterClosureVariable: aVariable [
	outerClosureVariables add: aVariable
	
]

{ #category : #adding }
LowtalkInterpreterMethod >> addPragma: aPragma [
	^ self pragmas add: aPragma
]

{ #category : #adding }
LowtalkInterpreterMethod >> addTemporary: temporary [
	temporaries add: temporary
]

{ #category : #accessing }
LowtalkInterpreterMethod >> arguments [
	^ arguments
]

{ #category : #accessing }
LowtalkInterpreterMethod >> arguments: anObject [
	arguments := anObject
]

{ #category : #converting }
LowtalkInterpreterMethod >> asLowtalkObjectInstanceWith: aCompiler [
	^ aCompiler generateInterpreterMethod: self
]

{ #category : #evaluating }
LowtalkInterpreterMethod >> bytecodeMethodWithEnvironment: closureEnvironment compiler: aLowtalkCompiler [
	| bytecodeMethod |
	bytecodeMethods at: closureEnvironment ifPresent: [ :compiledMethod | ^ compiledMethod ].
	"Transcript show: 'Generate compiled method at '; show: node position; cr."
	bytecodeMethod := LowtalkCompiledMethodGenerator new
		compiler: aLowtalkCompiler;
		generateInterpreterMethod: self closureEnvironment: closureEnvironment.
	bytecodeMethods at: closureEnvironment put: bytecodeMethod.
	"self halt."
	^ bytecodeMethod
]

{ #category : #'as yet unclassified' }
LowtalkInterpreterMethod >> closureWithEnvironment: aClosureEnvironment [
	^ LowtalkInterpreterMethodClosure new definition: self; environment: aClosureEnvironment
]

{ #category : #accessing }
LowtalkInterpreterMethod >> compiler [
	^ environment compiler
]

{ #category : #accessing }
LowtalkInterpreterMethod >> definition [
	^ self
]

{ #category : #accessing }
LowtalkInterpreterMethod >> environment [
	^ environment
]

{ #category : #accessing }
LowtalkInterpreterMethod >> environment: anObject [
	environment := anObject
]

{ #category : #evaluating }
LowtalkInterpreterMethod >> evaluateCompiledMethod: compiledMethod withArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode [
	"Process the receiver"
	| actualArguments actualArgumentTypes receiverValue receiverValueType argumentDefinition convertedArguments |
	actualArguments := evaluationArguments.
	actualArgumentTypes := evaluationArgumentTypes.
	receiverValue := nil.
	
	receiverType isVoidType ifFalse: [ 
		actualArguments ifEmpty: [ 
			aNode semanticError: 'Expected a receiver.'
		].
	
		receiverValue := actualArguments first.
		receiverValueType := actualArgumentTypes first.
		
		receiverValue := receiverValueType convertValue: receiverValue toType: receiverType at: aNode.

		actualArguments := actualArguments allButFirst.
		actualArgumentTypes := actualArgumentTypes allButFirst.
	].

	"Process the arguments"
	actualArguments size ~= arguments size ifTrue: [ 
		aNode semanticError: 'Expected {1} arguments instead of {2} arguments' format: {arguments size asString . actualArguments size asString}
	].

	"Convert the arguments"
	convertedArguments := actualArguments collectWithIndex: [ :arg :index |
		argumentDefinition := arguments at: index.
		(actualArgumentTypes at: index) convertValue: arg toType: argumentDefinition type at: aNode.
	].

	^ compiledMethod valueWithReceiver: receiverValue arguments: convertedArguments
]

{ #category : #accessing }
LowtalkInterpreterMethod >> hasLazySelector [
	^ hasLazySelector
]

{ #category : #accessing }
LowtalkInterpreterMethod >> hasLocalReturns [
	^ hasLocalReturns
]

{ #category : #accessing }
LowtalkInterpreterMethod >> hasLocalReturns: anObject [
	hasLocalReturns := anObject
]

{ #category : #initialization }
LowtalkInterpreterMethod >> initialize [
	super initialize.
	arguments := #().
	temporaries := OrderedCollection new.
	hasLazySelector := false.
	bytecodeMethods := IdentityDictionary new.
	capturedVariable := SLVMOrderedInsertionSet new.
	outerClosureVariables := SLVMOrderedInsertionSet new.
]

{ #category : #accessing }
LowtalkInterpreterMethod >> inlineMode [
	^ inlineMode
]

{ #category : #accessing }
LowtalkInterpreterMethod >> inlineMode: anObject [
	inlineMode := anObject
]

{ #category : #evaluating }
LowtalkInterpreterMethod >> interpretASTWithArguments: evaluationArguments types: evaluationArgumentTypes closureEnvironment: closureEnvironment compiler: aLowtalkCompiler at: aNode [
	| activationEnvironment argumentDefinition convertedArgument argumentVariable result resultType actualArguments actualArgumentTypes receiverValue receiverValueType receiverActivationEnvironment |
	
	"Process the receiver"
	actualArguments := evaluationArguments.
	actualArgumentTypes := evaluationArgumentTypes.
	receiverValue := nil.
	
	receiverActivationEnvironment := closureEnvironment.
	receiverType isVoidType ifFalse: [ 
		actualArguments ifEmpty: [ 
			aNode semanticError: 'Expected a receiver.'
		].
	
		receiverValue := actualArguments first.
		receiverValueType := actualArgumentTypes first.
		
		receiverValue := receiverValueType convertValue: receiverValue toType: receiverType at: aNode.
		receiverActivationEnvironment := (LowtalkReceiverEnvironment parent: closureEnvironment)
			receiverType: receiverType;
			receiver: receiverValue;
			yourself.
		
		actualArguments := actualArguments allButFirst.
		actualArgumentTypes := actualArgumentTypes allButFirst.
	].

	activationEnvironment := LowtalkLocalEnvironment parent: receiverActivationEnvironment.
		
	"Process the arguments"
	actualArguments size ~= arguments size ifTrue: [ 
		aNode semanticError: 'Expected {1} arguments instead of {2} arguments' format: {arguments size asString . actualArguments size asString}
	].

	actualArguments doWithIndex: [ :arg :index |
		argumentDefinition := arguments at: index.
		convertedArgument := (actualArgumentTypes at: index) convertValue: arg toType: argumentDefinition type at: aNode.
		argumentVariable := LowtalkCompileTimeArgumentLocalVariable new
			name: argumentDefinition name;
			value: arg;
			valueType: argumentDefinition type;
			compiler: aLowtalkCompiler;
			yourself.
		activationEnvironment setSymbol: argumentVariable name value: argumentVariable
	].
	
	result := nil.
	hasLocalReturns ifFalse: [ 
		result := LowtalkEvaluator evaluate: node body environment: activationEnvironment.
		resultType := node body type.
	] ifTrue: [ 
		receiverType isVoidType ifFalse: [
			result := receiverValue.
			resultType := receiverType.
		].
	
		resultType ifNil: [ resultType := aLowtalkCompiler objectType ].

		node body expressions ifNotEmpty: [ 
			[
				LowtalkEvaluator evaluate: node body environment: activationEnvironment.
			] on: LowtalkInterpreterReturnException do: [ :returnExc |
				result := returnExc value.
				resultType := returnExc type.
			]
		]
	].
	
	^ returnType isVoidType ifTrue: [nil] ifFalse: [resultType convertValue: result toType: returnType at: node]
]

{ #category : #testing }
LowtalkInterpreterMethod >> isInlined [
	^ inlineMode isNotNil and: [ inlineMode ~~ false ]
]

{ #category : #evaluating }
LowtalkInterpreterMethod >> lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes closureEnvironment: closureEnvironment compiler: aLowtalkCompiler at: aNode [
	self hasLazySelector ifFalse: [
		(self bytecodeMethodWithEnvironment: closureEnvironment compiler: aLowtalkCompiler) ifNotNil: [ :compiledMethod |
			^ self evaluateCompiledMethod: compiledMethod withArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode
		]
	].

	^ self interpretASTWithArguments: evaluationArguments types: evaluationArgumentTypes closureEnvironment: closureEnvironment compiler: aLowtalkCompiler at: aNode
]

{ #category : #evaluating }
LowtalkInterpreterMethod >> lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode [
	^ self lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes closureEnvironment: environment compiler: aLowtalkCompiler at: aNode
]

{ #category : #'as yet unclassified' }
LowtalkInterpreterMethod >> markLazySelectorPresence [
	hasLazySelector ifTrue: [ ^ true ].
	
	hasLazySelector := true.
	(parentMethod isNotNil and: [hasLocalReturns not]) ifTrue: [
		parentMethod markLazySelectorPresence
	]
]

{ #category : #accessing }
LowtalkInterpreterMethod >> methodClass [
	^ receiverType
]

{ #category : #accessing }
LowtalkInterpreterMethod >> node [
	^ node
]

{ #category : #accessing }
LowtalkInterpreterMethod >> node: anObject [
	node := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethod >> outerClosureVariables [
	^ outerClosureVariables
]

{ #category : #accessing }
LowtalkInterpreterMethod >> parentMethod [
	^ parentMethod
]

{ #category : #accessing }
LowtalkInterpreterMethod >> parentMethod: anObject [
	parentMethod := anObject
]

{ #category : #'as yet unclassified' }
LowtalkInterpreterMethod >> pointerForSlotDescription: slotDescription [
	^ LowtalkMethodReceiverSlot new description: slotDescription
]

{ #category : #accessing }
LowtalkInterpreterMethod >> pragmas [
	^ pragmas ifNil: [pragmas := OrderedCollection new.]
]

{ #category : #accessing }
LowtalkInterpreterMethod >> primitive [
	^ primitive
]

{ #category : #accessing }
LowtalkInterpreterMethod >> primitive: anObject [
	primitive := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethod >> publicSymbol [
	^ publicSymbol
]

{ #category : #accessing }
LowtalkInterpreterMethod >> publicSymbol: anObject [
	publicSymbol := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethod >> receiverSSAValue [
	^ receiverSSAValue
]

{ #category : #accessing }
LowtalkInterpreterMethod >> receiverSSAValue: anObject [
	receiverSSAValue := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethod >> receiverType [
	^ receiverType
]

{ #category : #accessing }
LowtalkInterpreterMethod >> receiverType: anObject [
	receiverType := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethod >> returnType [
	^ returnType
]

{ #category : #accessing }
LowtalkInterpreterMethod >> returnType: anObject [
	returnType := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethod >> selector [
	<compileTime>
	^ selector
]

{ #category : #accessing }
LowtalkInterpreterMethod >> selector: anObject [
	<compileTime>
	selector := anObject
]

{ #category : #'as yet unclassified' }
LowtalkInterpreterMethod >> selectorRequiredLiteral [
	| additionalMethodState |
	(pragmas isNotNil and: [ pragmas isNotEmpty ]) ifTrue: [
		additionalMethodState := AdditionalMethodState forSelector: selector.
		pragmas do: [ :pragma |
			additionalMethodState := additionalMethodState copyWith: pragma
		].
		^ additionalMethodState
	].

	^ selector
]

{ #category : #accessing }
LowtalkInterpreterMethod >> ssaFunction [
	^ ssaFunction
]

{ #category : #accessing }
LowtalkInterpreterMethod >> ssaFunction: anObject [
	ssaFunction := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethod >> temporaries [
	^ temporaries
]

{ #category : #accessing }
LowtalkInterpreterMethod >> type [
	^ type
]

{ #category : #accessing }
LowtalkInterpreterMethod >> type: anObject [
	type := anObject
]

{ #category : #accessing }
LowtalkInterpreterMethod >> unmangledName [
	^ unmangledName
]

{ #category : #accessing }
LowtalkInterpreterMethod >> unmangledName: anObject [
	unmangledName := anObject
]
