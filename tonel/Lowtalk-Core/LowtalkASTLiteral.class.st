Class {
	#name : #LowtalkASTLiteral,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'value'
	],
	#category : 'Lowtalk-Core-AST'
}

{ #category : #converting }
LowtalkASTLiteral >> asLiteralValue [
	^ value
]

{ #category : #testing }
LowtalkASTLiteral >> isLiteralNode [
	^ true
]

{ #category : #printing }
LowtalkASTLiteral >> printOn: aStream [
	aStream nextPutAll: '(literal '; print: value;  nextPut: $)
]

{ #category : #accessing }
LowtalkASTLiteral >> value [
	^ value
]

{ #category : #accessing }
LowtalkASTLiteral >> value: anObject [
	value := anObject
]
