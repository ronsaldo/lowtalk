Class {
	#name : #LowtalkASTPragma,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTPragma >> accept: aVisitor [
	^ aVisitor visitPragmaNode: self
]

{ #category : #accessing }
LowtalkASTPragma >> arguments [
	^ arguments
]

{ #category : #accessing }
LowtalkASTPragma >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
LowtalkASTPragma >> selector [
	^ selector
]

{ #category : #accessing }
LowtalkASTPragma >> selector: anObject [
	selector := anObject
]
