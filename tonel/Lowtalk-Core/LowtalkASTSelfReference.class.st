Class {
	#name : #LowtalkASTSelfReference,
	#superclass : #LowtalkASTExpression,
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTSelfReference >> accept: aVisitor [
	^ aVisitor visitSelfNode: self
]

{ #category : #testing }
LowtalkASTSelfReference >> isSelf [
	^ true
]

{ #category : #printing }
LowtalkASTSelfReference >> printOn: aStream [
	aStream nextPutAll: 'self'
]
