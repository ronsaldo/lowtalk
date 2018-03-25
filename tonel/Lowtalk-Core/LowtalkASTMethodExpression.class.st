Class {
	#name : #LowtalkASTMethodExpression,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'selector',
		'returnTypeExpression',
		'arguments',
		'body'
	],
	#category : 'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTMethodExpression >> accept: aVisitor [
	^ aVisitor visitMethodExpression: self
]

{ #category : #accessing }
LowtalkASTMethodExpression >> arguments [
	^ arguments
]

{ #category : #accessing }
LowtalkASTMethodExpression >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
LowtalkASTMethodExpression >> body [
	^ body
]

{ #category : #accessing }
LowtalkASTMethodExpression >> body: anObject [
	body := anObject
]

{ #category : #initialization }
LowtalkASTMethodExpression >> initialize [
	super initialize.
	arguments := #().

]

{ #category : #accessing }
LowtalkASTMethodExpression >> pragmaAt: aPragmaName ifPresent: aBlock [
	^ body pragmaAt: aPragmaName ifPresent: aBlock
]

{ #category : #accessing }
LowtalkASTMethodExpression >> returnTypeExpression [
	^ returnTypeExpression
]

{ #category : #accessing }
LowtalkASTMethodExpression >> returnTypeExpression: anObject [
	returnTypeExpression := anObject
]

{ #category : #accessing }
LowtalkASTMethodExpression >> selector [
	^ selector
]

{ #category : #accessing }
LowtalkASTMethodExpression >> selector: anObject [
	selector := anObject
]
