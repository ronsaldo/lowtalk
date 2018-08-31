Class {
	#name : #LowtalkASTExpressionList,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'expressions',
		'pragmaList',
		'locals'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTExpressionList >> accept: aVisitor [
	^ aVisitor visitExpressionListNode: self
]

{ #category : #accessing }
LowtalkASTExpressionList >> expressions [
	^ expressions
]

{ #category : #accessing }
LowtalkASTExpressionList >> expressions: anObject [
	expressions := anObject
]

{ #category : #enumerating }
LowtalkASTExpressionList >> hasPragmaNamed: aPragmaName [
	pragmaList do: [ :pragma | pragma selector == aPragmaName ifTrue: [^ true ]].
	^ false
]

{ #category : #accessing }
LowtalkASTExpressionList >> locals [
	^ locals
]

{ #category : #accessing }
LowtalkASTExpressionList >> locals: anObject [
	locals := anObject ifNil: [ #() ]
]

{ #category : #enumerating }
LowtalkASTExpressionList >> pragmaAt: aPragmaName [
	^ self pragmaAt: aPragmaName ifAbsent: [self error: 'Failed to find pragma']
]

{ #category : #enumerating }
LowtalkASTExpressionList >> pragmaAt: aPragmaName ifAbsent: aBlock [
	pragmaList do: [ :pragma | pragma selector == aPragmaName ifTrue: [ ^ pragma ]].
	^ aBlock value
]

{ #category : #enumerating }
LowtalkASTExpressionList >> pragmaAt: aPragmaName ifPresent: aBlock [
	pragmaList do: [ :pragma | pragma selector == aPragmaName ifTrue: [ ^ aBlock value: pragma ]].
]

{ #category : #accessing }
LowtalkASTExpressionList >> pragmaList [
	^ pragmaList
]

{ #category : #accessing }
LowtalkASTExpressionList >> pragmaList: anObject [
	pragmaList := anObject.
]

{ #category : #enumerating }
LowtalkASTExpressionList >> pragmasDo: aBlock [
	^ pragmaList do: aBlock
]

{ #category : #printing }
LowtalkASTExpressionList >> printOn: aStream [
	aStream nextPutAll: '(seq'.
	expressions do: [ :expr |
		aStream cr; tab; print: expr
	].
	aStream nextPut: $)
]
