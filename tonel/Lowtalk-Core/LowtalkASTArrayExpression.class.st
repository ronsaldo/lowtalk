Class {
	#name : #LowtalkASTArrayExpression,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'expressionList'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTArrayExpression >> accept: aVisitor [
	^ aVisitor visitArrayNode: self
]

{ #category : #accessing }
LowtalkASTArrayExpression >> expressionList [
	^ expressionList
]

{ #category : #accessing }
LowtalkASTArrayExpression >> expressionList: anObject [
	expressionList := anObject
]

{ #category : #printing }
LowtalkASTArrayExpression >> printOn: aStream [
	aStream nextPutAll: '(array '; print: expressionList; nextPut:$)
]
