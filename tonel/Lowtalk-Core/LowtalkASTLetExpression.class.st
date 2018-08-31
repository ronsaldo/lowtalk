Class {
	#name : #LowtalkASTLetExpression,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'identifier',
		'typeExpression',
		'initialValue',
		'valueType',
		'binding'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTLetExpression >> accept: aVisitor [
	^ aVisitor visitLetExpressionNode: self
]

{ #category : #accessing }
LowtalkASTLetExpression >> binding [
	^ binding
]

{ #category : #accessing }
LowtalkASTLetExpression >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
LowtalkASTLetExpression >> identifier [
	^ identifier
]

{ #category : #accessing }
LowtalkASTLetExpression >> identifier: anObject [
	identifier := anObject
]

{ #category : #accessing }
LowtalkASTLetExpression >> initialValue [
	^ initialValue
]

{ #category : #accessing }
LowtalkASTLetExpression >> initialValue: anObject [
	initialValue := anObject
]

{ #category : #accessing }
LowtalkASTLetExpression >> typeExpression [
	^ typeExpression
]

{ #category : #accessing }
LowtalkASTLetExpression >> typeExpression: anObject [
	typeExpression := anObject
]

{ #category : #accessing }
LowtalkASTLetExpression >> valueType [
	^ valueType
]

{ #category : #accessing }
LowtalkASTLetExpression >> valueType: anObject [
	valueType := anObject
]
