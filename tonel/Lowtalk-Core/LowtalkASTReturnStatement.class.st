Class {
	#name : #LowtalkASTReturnStatement,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'value'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTReturnStatement >> accept: aVisitor [
	^ aVisitor visitReturnNode: self
]

{ #category : #printing }
LowtalkASTReturnStatement >> printOn: aStream [
	aStream nextPutAll: '(return '; print: value; nextPut: $)
]

{ #category : #accessing }
LowtalkASTReturnStatement >> value [
	^ value
]

{ #category : #accessing }
LowtalkASTReturnStatement >> value: anObject [
	value := anObject
]
