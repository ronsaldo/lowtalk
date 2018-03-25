Class {
	#name : #LowtalkEvaluator,
	#superclass : #LowtalkSemanticAnalyzer,
	#classVars : [
		'BlockMessages',
		'InlineMessages'
	],
	#category : 'Lowtalk-Core-Interpreter'
}

{ #category : #'public access' }
LowtalkEvaluator class >> evaluate: aNode environment: anEnvironment [
	^ self new environment: anEnvironment; evaluate: aNode
]

{ #category : #'public access' }
LowtalkEvaluator class >> evaluateValue: aNode environment: anEnvironment [
	^ self new environment: anEnvironment; evaluateValue: aNode
]

{ #category : #initialization }
LowtalkEvaluator class >> initialize [
	
	InlineMessages := Dictionary newFromPairs: #(
		ifNil: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifNotNil: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifTrue: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifFalse: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		
		ifNil:ifNotNil: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifNotNil:ifNil: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifTrue:ifFalse: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
		ifFalse:ifFalse: evaluateInlineIfMessage:receiver:receiverType:inSuperclass:
	).
	
	BlockMessages := Dictionary newFromPairs: #(
		whileTrue WhileLoop
		whileTrue: WhileLoop
		whileFalse WhileLoop
		whileFalse: WhileLoop
		whileNotNil: WhileLoop
		whileNil: WhileLoop
	).
]

{ #category : #visiting }
LowtalkEvaluator >> asEvaluator [
	^ self
]

{ #category : #'as yet unclassified' }
LowtalkEvaluator >> cullInlineBlock: aBlockNode arguments: blockCullArguments at: aNode [
	blockCullArguments size <  aBlockNode arguments size ifTrue: [ 
		aNode semanticError: 'Inlined block expects {1} arguments and receives {2} arguments'
			format: { aBlockNode arguments size asString . blockCullArguments size asString }
	].

	self halt.
]

{ #category : #'as yet unclassified' }
LowtalkEvaluator >> cullInlineBlock: aBlockNode arguments: cullArguments types: cullArgumentTypes at: aNode [
	| argumentCount |
	cullArguments size <  aBlockNode arguments size ifTrue: [ 
		aNode semanticError: 'Inlined block expects {1} arguments and receives {2} arguments'
			format: { aBlockNode arguments size asString . cullArguments size asString }
	].

	argumentCount := aBlockNode arguments size.
	^ self evaluateInlineBlock: aBlockNode arguments: (cullArguments first: argumentCount) types: (cullArgumentTypes first: argumentCount) at: aNode

]

{ #category : #'as yet unclassified' }
LowtalkEvaluator >> evaluateInlineBlock: aBlockNode arguments: blockArguments types: blockArgumentTypes at: aNode [
	| activationEnvironment argumentDefinition convertedArgument argumentVariable result resultType |
	self solveBlockType: aBlockNode.
	activationEnvironment := LowtalkLocalEnvironment parent: environment.
	
	blockArguments collectWithIndex: [ :arg :index |
		argumentDefinition := aBlockNode arguments at: index.
		convertedArgument := (blockArgumentTypes at: index) convertValue: arg toType: argumentDefinition type at: aNode.
		argumentVariable := LowtalkCompileTimeArgumentLocalVariable new
			name: argumentDefinition name;
			value: arg;
			valueType: argumentDefinition type;
			compiler: self compiler;
			yourself.
		activationEnvironment setSymbol: argumentVariable name value: argumentVariable
	].
	
	result := LowtalkEvaluator evaluate: aBlockNode body environment: activationEnvironment.
	resultType := aBlockNode body type.
	^ resultType convertValue: result toType: aBlockNode returnType at: aNode
]

{ #category : #'as yet unclassified' }
LowtalkEvaluator >> evaluateInlineIfMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass [
	| selector blockCullArguments blockIndex emptyResult blockCullArgumentTypes result resultType |
	selector := message selector.	
	blockCullArguments := #().
	blockCullArgumentTypes := #().
	emptyResult := receiver.
	(#(ifNil: ifNotNil: ifNil:ifNotNil: ifNotNil:ifNil:) includes: selector) ifTrue: [ 
		receiver ifNil: [
			blockIndex := (#(ifNil: ifNil:ifNotNil:) includes: selector) ifTrue: [ 1 ] ifFalse: [ 2 ].
		] ifNotNil: [
			blockIndex := (#(ifNotNil: ifNotNil:ifNil:) includes: selector) ifTrue: [ 1 ] ifFalse: [ 2 ].
			blockCullArguments := { receiver }.
			blockCullArgumentTypes := { receiverType withoutReferences }
		]
	].

	(#(ifTrue: ifFalse: ifTrue:ifFalse: ifFalse:ifTrue:) includes: selector) ifTrue: [ 
		emptyResult := nil.
		receiver == true ifTrue: [
			blockIndex := (#(ifTrue: ifTrue:ifFalse:) includes: selector) ifTrue: [ 1 ] ifFalse: [ 2 ].
		] ifFalse: [ 
			receiver == false ifTrue: [
				blockIndex := (#(ifFalse: ifFalse:ifTrue:) includes: selector) ifTrue: [ 1 ] ifFalse: [ 2 ].
			] ifFalse: [
				^ self evaluateNormalMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass
			]
		].
	].

	blockIndex > message arguments size ifTrue: [ ^ emptyResult ].
	result := self cullInlineBlock: (message arguments at: blockIndex) arguments: blockCullArguments types: blockCullArgumentTypes at: message.
	resultType := (message arguments at: blockIndex) type withoutReferences returnType.
	^ resultType convertValue: result toType: message type at: message
]

{ #category : #'as yet unclassified' }
LowtalkEvaluator >> evaluateInlineWhileMessage: message [
	| selector blockCullArguments blockCullArgumentTypes condition |
	selector := message selector.	
	blockCullArguments := #().
	blockCullArgumentTypes := #().
	
	condition := nil.
	
	#whileFalse: == selector ifTrue: [
		condition := [ :value | value == false ]
	].
	#whileTrue: == selector ifTrue: [
		condition := [ :value | value == true ]
	].
	#whileNil: == selector ifTrue: [
		condition := [ :value | value == nil ]
	].
	#whileNotNil: == selector ifTrue: [
		condition := [ :value | value ~~ nil ]
	].

	[ condition value: (self evaluateInlineBlock: message receiver arguments: #() types: #() at: message) ] whileTrue:
	[
		self evaluateInlineBlock: message arguments first arguments: #() types: #() at: message
	].
	^ nil
]

{ #category : #visiting }
LowtalkEvaluator >> evaluateMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass [
	message compileTimeValue ifNotNil: [ ^ message compileTimeValue ].
	InlineMessages at: message selector ifPresent: [ :inlineSelector |
		^ self perform: inlineSelector withArguments: { message . receiver . receiverType . superClass }
	].
 	^ self evaluateNormalMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass

]

{ #category : #'as yet unclassified' }
LowtalkEvaluator >> evaluateNormalMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass [
	| arguments argumentTypes |
	<lowtalkEnvironmentHolder>
 
	receiverType isCompileTimeType ifTrue: [
		receiver isNamespace ifTrue: [ 
			message selector precedence = 1 ifTrue: [
				^ self setCompileTimeValue: (receiver lookSymbol: message selector ifAbsent: [
					message semanticError: 'Namespace {1} does not have member named {2}' format: { receiver name . message selector }
				]) in: message.
			].
		].
	].

	(self compiler isLazySelector: message selector) ifTrue: [ 
		arguments := message arguments collect: [ :arg |
			LowtalkLazyValue new evaluator: self; node: arg
		].

		^ receiver lowtalkPerform: message selector withLazyArguments: arguments inSuperclass: superClass node: message compiler: compiler
	] ifFalse: [ 
		arguments := message arguments collect: [ :arg | self visitNode: arg].
		argumentTypes := message arguments collect: [ :arg | arg type withoutReferences ].

		message arguments doWithIndex: [ :arg :index |
			| argType |
			argType := argumentTypes at: index.
			arguments at: index put: (arg type convertValue: (arguments at: index) toType: argType at: arg)
		].

		^ receiver lowtalkPerform: message selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: message compiler: compiler
	].

]

{ #category : #'public access' }
LowtalkEvaluator >> evaluateValue: aNode [
	| result |
	result := self evaluate: aNode.
	^ self removeReferencesOfValue: result type: aNode type.
]

{ #category : #'public access' }
LowtalkEvaluator >> inferType: aNode [
	^ self asTypeInferenceEvaluator evaluate: aNode
]

{ #category : #'public access' }
LowtalkEvaluator >> removeReferencesOfValue: value type: aType [
	| currentType result |
	self assert: aType isNotNil.
	currentType := aType.
	result := value.
	[ currentType isReferenceType ] whileTrue: [ 
		result := result value.
		currentType := currentType referenced.
	].
	^ result
]

{ #category : #visiting }
LowtalkEvaluator >> setCompileTimeValue: value in: node [
	node compileTimeValue: value.
	node type: value type.
	^ node compileTimeValue
]

{ #category : #visiting }
LowtalkEvaluator >> visitArrayLiteralNode: literal [
	literal setTypeIfNil: self compiler objectType.
	^ literal value
]

{ #category : #visiting }
LowtalkEvaluator >> visitArrayNode: node [
	node setTypeIfNil: compiler objectType.
	^ node expressionList collect: [ :element | self evaluateValue: element ].
]

{ #category : #visiting }
LowtalkEvaluator >> visitAssignmentNode: node [
	| value reference referenceType expectedType |
	value := self visitNode: node value.
	reference := self visitNode: node reference.
	
	referenceType := node reference type.
	referenceType isReferenceType ifFalse: [
		node semanticError: 'Expected a reference to perform assignment instead of value of type {1}.' format: { referenceType name }
	].

	"Make sure the value can be converted to the expected type."
	expectedType := referenceType referenced.
	node value type implicitlyConvertedTo: expectedType at: node.
	value := node value type convertValue: value toType: expectedType at: node.

	"Set the value"
	reference value: value.
	
	"Set the result type."	
	node setTypeIfNil: referenceType.
	^ reference
]

{ #category : #visiting }
LowtalkEvaluator >> visitBlockNode: aBlockNode [
	(aBlockNode body hasPragmaNamed: #compileTimeOnly) ifTrue: [
		aBlockNode type: compiler objectType.
		^ LowtalkCompileTimeOnlyBlock new
			compiler: compiler;
			node: aBlockNode;
			environment: environment;
			yourself
	].

	aBlockNode definition ifNil: [
		aBlockNode definition: (LowtalkMethodSemanticAnalyzer new analyzeBlock: aBlockNode environment: environment).
	].

	^ aBlockNode definition closureWithEnvironment: environment
	
]

{ #category : #visiting }
LowtalkEvaluator >> visitBooleanLiteralNode: aNode [
	aNode setTypeIfNil: compiler booleanType.
	^ aNode value
]

{ #category : #visiting }
LowtalkEvaluator >> visitCallExpression: expression [
	| receiver receiverType returnType expectedArgumentTypes arguments |
	receiver := self evaluateValue: expression receiver.
	receiverType := expression receiver type withoutReferences.
	returnType := compiler objectType.
	(receiverType isFunctionType or: [ receiverType isBlockType ]) ifTrue: [ 
		returnType := receiverType returnType.
		expectedArgumentTypes := receiverType arguments.
	] ifFalse: [
		expectedArgumentTypes := expression arguments collect: [ :a | compiler objectType ].
	].

	expression setTypeIfNil: returnType.

	arguments := expression arguments collectWithIndex: [ :arg :index |
		|argumentValue|
		argumentValue := self visitNode: arg.
		arg type convertValue: argumentValue toType: (expectedArgumentTypes at: index) at: arg 
	].

	^ receiver lowtalkValueWithArguments: arguments types: expectedArgumentTypes compiler: compiler at: expression.
]

{ #category : #visiting }
LowtalkEvaluator >> visitCharacterLiteralNode: literal [
	literal setTypeIfNil: self compiler characterLiteralType.
	^ literal value
]

{ #category : #visiting }
LowtalkEvaluator >> visitExpressionListNode: expressionList [
	| result resultType |
	result := nil.
	resultType := self compiler objectType.
	expressionList expressions do: [ :expr |
		result := self evaluate: expr.
		resultType := expr type.
	].
	expressionList setTypeIfNil: resultType.
	^ result

]

{ #category : #visiting }
LowtalkEvaluator >> visitFloatLiteralNode: literal [
	literal setTypeIfNil: self compiler floatLiteralType.
	^ literal value
]

{ #category : #visiting }
LowtalkEvaluator >> visitIntegerLiteralNode: literal [
	literal setTypeIfNil: self compiler integerLiteralType.
	^ literal value
]

{ #category : #visiting }
LowtalkEvaluator >> visitLetExpressionNode: node [
	| initialValue variable |
	node typeExpression ifNotNil: [
		node valueType: (self solveTypeExpression: node typeExpression).
	].

	"Check the node value"
	node initialValue ifNotNil: [
		initialValue := self visitNode: node initialValue.
		node valueType ifNil: [
			node valueType: (initialValue lowtalkInferTypeForNodeType: node initialValue type asValueType)
		] ifNotNil: [ 
			node initialValue type implicitlyConvertedTo: node valueType at: node
		].
		initialValue := node initialValue type convertValue: initialValue toType: node valueType at: node
	] ifNil: [
		node valueType ifNil: [ node valueType: compiler objectType ].
		initialValue := node valueType defaultValue
	].

	variable := LowtalkCompileTimeLocalVariable new
			name: node identifier;
			value: initialValue;
			valueType: node valueType;
			compiler: self compiler;
			yourself.
	environment setSymbol: variable name value: variable ifPresent: [
		node semanticError: 'Variable name {1} is already in use in this scope.' format: { variable name printString }.
	].

	node setTypeIfNil: node valueType ref.
	^ variable
]

{ #category : #visiting }
LowtalkEvaluator >> visitMessageChainNode: messageChain [
	| receiver result superClass |
	receiver := self evaluateValue: messageChain receiver.
	superClass := messageChain receiver superClassForValue: receiver.
	result := receiver.
	messageChain messages do: [ :message |
		self solveMessageType: message withReceiverType: messageChain receiver type.
		result := self evaluateMessage: message receiver: receiver receiverType: messageChain receiver type inSuperclass: superClass.
		messageChain setTypeIfNil: message type.
	].

	^ result
]

{ #category : #visiting }
LowtalkEvaluator >> visitMessageNode: messageNode [
	| receiver superClass |
	messageNode compileTimeValue ifNotNil: [ ^ messageNode compileTimeValue ].
	(messageNode receiver isBlockNode and: [ BlockMessages includesKey: messageNode selector ]) ifTrue: [
		^ self evaluateInlineWhileMessage: messageNode
	].
	
	receiver := self evaluateValue: messageNode receiver.
	self solveMessageType: messageNode withReceiverType: messageNode receiver type.
	superClass := messageNode receiver superClassForValue: receiver.
	^ self evaluateMessage: messageNode receiver: receiver receiverType: messageNode receiver type inSuperclass: superClass
]

{ #category : #visiting }
LowtalkEvaluator >> visitMethodExpression: aMethodNode [
	aMethodNode setTypeIfNil: compiler objectType.
	^ LowtalkInterpreterMethodExpression new
		node: aMethodNode;
		environment: environment;
		compiler: self compiler;
		yourself
]

{ #category : #visiting }
LowtalkEvaluator >> visitNilLiteralNode: aNode [
	aNode setTypeIfNil: compiler nilType.
	^ nil
]

{ #category : #visiting }
LowtalkEvaluator >> visitObjectLiteralNode: node [
	node type: self compiler objectType.
	^ node value
]

{ #category : #visiting }
LowtalkEvaluator >> visitReturnNode: node [
	| returnValue |
	returnValue := self visitNode: node value.
	LowtalkInterpreterReturnException new
		value: returnValue;
		type: node value type;
		signal
]

{ #category : #visiting }
LowtalkEvaluator >> visitSelfNode: aNode [
	aNode setTypeIfNil: environment receiverType.
	^ environment receiver
]

{ #category : #visiting }
LowtalkEvaluator >> visitStringLiteralNode: literal [
	literal setTypeIfNil: self compiler stringLiteralType.
	^ literal value
]

{ #category : #visiting }
LowtalkEvaluator >> visitSuperNode: aNode [
	aNode setTypeIfNil: environment receiverType.
	^ environment receiver
]

{ #category : #visiting }
LowtalkEvaluator >> visitSymbolLiteralNode: literal [
	literal setTypeIfNil: self compiler symbolLiteralType.
	^ literal value
]
