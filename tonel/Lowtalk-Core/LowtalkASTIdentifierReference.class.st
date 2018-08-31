Class {
	#name : #LowtalkASTIdentifierReference,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'value',
		'binding'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTIdentifierReference >> accept: aVisitor [
	^ aVisitor visitIdentifierReferenceNode: self
]

{ #category : #converting }
LowtalkASTIdentifierReference >> asLiteralValue [
	^ value
]

{ #category : #accessing }
LowtalkASTIdentifierReference >> binding [
	^ binding
]

{ #category : #accessing }
LowtalkASTIdentifierReference >> binding: anObject [
	binding := anObject
]

{ #category : #testing }
LowtalkASTIdentifierReference >> isIdentifierReference [
	^ true
]

{ #category : #printing }
LowtalkASTIdentifierReference >> printOn: aStream [
	aStream nextPutAll: value
]

{ #category : #accessing }
LowtalkASTIdentifierReference >> value [
	^ value
]

{ #category : #accessing }
LowtalkASTIdentifierReference >> value: anObject [
	value := anObject
]
