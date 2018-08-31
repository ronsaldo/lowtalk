Class {
	#name : #LowtalkASTCallExpression,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'receiver',
		'arguments'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTCallExpression >> accept: aVisitor [
	^ aVisitor visitCallExpression: self
]

{ #category : #accessing }
LowtalkASTCallExpression >> arguments [
	^ arguments
]

{ #category : #accessing }
LowtalkASTCallExpression >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
LowtalkASTCallExpression >> receiver [
	^ receiver
]

{ #category : #accessing }
LowtalkASTCallExpression >> receiver: anObject [
	receiver := anObject
]
