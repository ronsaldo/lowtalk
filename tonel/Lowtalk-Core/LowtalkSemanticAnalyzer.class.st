Class {
	#name : #LowtalkSemanticAnalyzer,
	#superclass : #LowtalkASTVisitor,
	#instVars : [
		'environment',
		'compiler'
	],
	#classVars : [
		'CallingConventionNames'
	],
	#category : 'Lowtalk-Core-Interpreter'
}

{ #category : #initialization }
LowtalkSemanticAnalyzer class >> initialize [
	CallingConventionNames := Set newFrom: #(
		cdecl
		stdcall
		smalltalk
		smalltalk_send
		smalltalk_supersend
		naked
	)
]

{ #category : #converting }
LowtalkSemanticAnalyzer >> asEvaluator [
	^ LowtalkEvaluator new environment: environment
]

{ #category : #converting }
LowtalkSemanticAnalyzer >> asTypeInferenceEvaluator [
	^ LowtalkTypeInferenceEvaluator new environment: environment
]

{ #category : #accessing }
LowtalkSemanticAnalyzer >> compiler [
	^ compiler ifNil: [compiler := environment compiler]
]

{ #category : #accessing }
LowtalkSemanticAnalyzer >> environment [
	^ environment
]

{ #category : #accessing }
LowtalkSemanticAnalyzer >> environment: anObject [
	environment := anObject
]

{ #category : #'public access' }
LowtalkSemanticAnalyzer >> evaluate: aNode [
	^ aNode accept: self
]

{ #category : #'as yet unclassified' }
LowtalkSemanticAnalyzer >> evaluateTypeExpression: typeExpression [
	^ (self asEvaluator evaluateValue: typeExpression) asLowtalkTypeIn: typeExpression.

]

{ #category : #'as yet unclassified' }
LowtalkSemanticAnalyzer >> solveBlockArgumentType: argument [
	argument type ifNil: [ 
		argument type: (self solveTypeExpression: argument typeExpression).
	]
	
	
]

{ #category : #'as yet unclassified' }
LowtalkSemanticAnalyzer >> solveBlockType: aBlockNode [
	| callingConvention argumentTypes |
	aBlockNode type ifNotNil: [ ^ self ].
	aBlockNode arguments do: [ :arg | self solveBlockArgumentType: arg ].
	aBlockNode returnType: (self solveTypeExpression: aBlockNode returnTypeExpression).
	aBlockNode selfType: (self solveTypeExpression: aBlockNode selfTypeExpression defaultType: compiler voidType).

	callingConvention := compiler defaultCallingConvention.
	aBlockNode pragmasDo: [ :pragma |
		(CallingConventionNames includes: pragma selector) ifTrue: [
			callingConvention := pragma selector
		]
	].

	argumentTypes := aBlockNode arguments collect: #type.
	aBlockNode selfType isVoidType ifFalse: [ 
		argumentTypes := { aBlockNode selfType } , argumentTypes
	].

	aBlockNode type: ((LowtalkFunctionType target: self compiler compilationTarget)
			arguments: argumentTypes;
			returnType: aBlockNode returnType;
			callingConvention: callingConvention;
			yourself) block.

]

{ #category : #visiting }
LowtalkSemanticAnalyzer >> solveMessageType: messageNode withReceiverType: receiverType [
	| actualReceiverType |
	messageNode type ifNotNil: [ ^ self ].
	actualReceiverType := receiverType withoutReferences.
	messageNode type: (actualReceiverType resultTypeForSelector: messageNode selector message: messageNode compiler: self compiler evaluator: self)
]

{ #category : #'as yet unclassified' }
LowtalkSemanticAnalyzer >> solveTypeExpression: typeExpression [
	^ self solveTypeExpression: typeExpression defaultType: self compiler objectType
]

{ #category : #'as yet unclassified' }
LowtalkSemanticAnalyzer >> solveTypeExpression: typeExpression defaultType: aDefaultType [
	^ typeExpression ifNotNil: [
		self evaluateTypeExpression: typeExpression
	] ifNil: [ 
		aDefaultType
	]
	
	
]

{ #category : #visiting }
LowtalkSemanticAnalyzer >> visitIdentifierReferenceNode: identifier [
	| result |
	result := (environment lookSymbolRecursively: identifier value ifAbsent: [
		identifier environment: environment semanticError: 'Undeclared identifier {1}' format: { identifier value }
	]) asLowtalkVariableReferenceFor: self compiler.

	identifier setTypeIfNil: result type.
	^ identifier type isReferenceType ifTrue: [ result ] ifFalse: [ result value ]
]
