Class {
	#name : #LowtalkASTLocalVariable,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'name',
		'valueType',
		'typeExpression',
		'binding'
	],
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTLocalVariable >> accept: aVisitor [
	^ aVisitor visitLocalVariableNode: self
]

{ #category : #accessing }
LowtalkASTLocalVariable >> binding [
	^ binding
]

{ #category : #accessing }
LowtalkASTLocalVariable >> binding: anObject [
	binding := anObject
]

{ #category : #accessing }
LowtalkASTLocalVariable >> name [
	^ name
]

{ #category : #accessing }
LowtalkASTLocalVariable >> name: anObject [
	name := anObject
]

{ #category : #accessing }
LowtalkASTLocalVariable >> typeExpression [
	^ typeExpression
]

{ #category : #accessing }
LowtalkASTLocalVariable >> typeExpression: anObject [
	typeExpression := anObject
]

{ #category : #accessing }
LowtalkASTLocalVariable >> valueType [
	^ valueType
]

{ #category : #accessing }
LowtalkASTLocalVariable >> valueType: anObject [
	valueType := anObject
]
