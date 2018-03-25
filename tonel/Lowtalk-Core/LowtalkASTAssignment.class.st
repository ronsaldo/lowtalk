Class {
	#name : #LowtalkASTAssignment,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'reference',
		'value'
	],
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTAssignment >> accept: aVisitor [
	^ aVisitor visitAssignmentNode: self
]

{ #category : #printing }
LowtalkASTAssignment >> printOn: aStream [
	aStream nextPutAll: '(assign '; print: reference; space; print: value; nextPut: $)
]

{ #category : #accessing }
LowtalkASTAssignment >> reference [
	^ reference
]

{ #category : #accessing }
LowtalkASTAssignment >> reference: anObject [
	reference := anObject
]

{ #category : #accessing }
LowtalkASTAssignment >> value [
	^ value
]

{ #category : #accessing }
LowtalkASTAssignment >> value: anObject [
	value := anObject
]
