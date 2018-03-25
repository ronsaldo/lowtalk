Class {
	#name : #LowtalkASTThisContextReference,
	#superclass : #LowtalkASTExpression,
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTThisContextReference >> accept: aVisitor [
	^ aVisitor visitThisContextNode: self
]

{ #category : #testing }
LowtalkASTThisContextReference >> isThisContext [
	^ true
]

{ #category : #visiting }
LowtalkASTThisContextReference >> printOn: aStream [
	aStream nextPutAll: 'thisContext'
]
