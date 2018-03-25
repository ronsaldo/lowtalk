Class {
	#name : #LowtalkTypeInferenceEvaluator,
	#superclass : #LowtalkSemanticAnalyzer,
	#category : 'Lowtalk-Core-Interpreter'
}

{ #category : #'public access' }
LowtalkTypeInferenceEvaluator class >> evaluate: aNode environment: anEnvironment [
	^ self new environment: anEnvironment; evaluate: aNode
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> asTypeInferenceEvaluator [
	^ self
]

{ #category : #'public access' }
LowtalkTypeInferenceEvaluator >> evaluate: aNode [
	aNode type ifNotNil: [ ^ aNode type ].
	^ super evaluate: aNode
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitBlockNode: aBlockNode [
	self solveBlockType: aBlockNode.
	^ aBlockNode type
	
]

{ #category : #visiting }
LowtalkTypeInferenceEvaluator >> visitBooleanLiteralNode: node [
	^ self compiler booleanLiteralType
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitCharacterLiteralNode: aNode [
	^ self compiler characterLiteralType
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitFloatLiteralNode: aNode [
	^ self compiler floatLiteralType
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitIdentifierReferenceNode: identifier [
	super visitIdentifierReferenceNode: identifier.
	^ identifier type
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitIntegerLiteralNode: aNode [
	^ self compiler integerLiteralType
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitMessageChainNode: messageChain [
	| receiverType resultType |
	receiverType := self evaluate: messageChain receiver.
	resultType := receiverType.
	messageChain messages do: [ :message |
		self solveMessageType: message withReceiverType: receiverType.
	].
	^ resultType
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitMessageNode: messageNode [
	| receiverType |
	receiverType := self evaluate: messageNode receiver.
	self solveMessageType: messageNode withReceiverType: messageNode receiver type.
	^ messageNode type
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitStringLiteralNode: aNode [
	^ self compiler stringLiteralType
]

{ #category : #accessing }
LowtalkTypeInferenceEvaluator >> visitSymbolLiteralNode: aNode [
	^ self compiler symbolLiteralType
]
