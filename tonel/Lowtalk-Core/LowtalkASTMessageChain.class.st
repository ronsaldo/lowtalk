Class {
	#name : #LowtalkASTMessageChain,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'receiver',
		'messages'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTMessageChain >> accept: aVisitor [
	^ aVisitor visitMessageChainNode: self
]

{ #category : #accessing }
LowtalkASTMessageChain >> messages [
	^ messages
]

{ #category : #accessing }
LowtalkASTMessageChain >> messages: anObject [
	messages := anObject.
	messages do: [ :message |
		message isCascaded: true
	]
]

{ #category : #printing }
LowtalkASTMessageChain >> printOn: aStream [
	aStream nextPutAll: '(chain '; print: receiver.
	messages do: [ :message | aStream space; print: message ].
	aStream nextPut: $)
]

{ #category : #accessing }
LowtalkASTMessageChain >> receiver [
	^ receiver
]

{ #category : #accessing }
LowtalkASTMessageChain >> receiver: anObject [
	receiver := anObject
]
