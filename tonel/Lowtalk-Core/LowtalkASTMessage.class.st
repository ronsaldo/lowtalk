Class {
	#name : #LowtalkASTMessage,
	#superclass : #LowtalkASTExpression,
	#instVars : [
		'selector',
		'receiver',
		'arguments',
		'compileTimeValue',
		'compileTimeMessageLookup',
		'specialMessageType',
		'coercionType',
		'isCascaded'
	],
	#category : #'Lowtalk-Core-AST'
}

{ #category : #visiting }
LowtalkASTMessage >> accept: aVisitor [
	^ aVisitor visitMessageNode: self
]

{ #category : #accessing }
LowtalkASTMessage >> arguments [
	^ arguments
]

{ #category : #accessing }
LowtalkASTMessage >> arguments: anObject [
	arguments := anObject
]

{ #category : #accessing }
LowtalkASTMessage >> coercionType [
	^ coercionType
]

{ #category : #accessing }
LowtalkASTMessage >> coercionType: anObject [
	coercionType := anObject
]

{ #category : #accessing }
LowtalkASTMessage >> compileTimeMessageLookup [
	^ compileTimeMessageLookup
]

{ #category : #accessing }
LowtalkASTMessage >> compileTimeMessageLookup: anObject [
	compileTimeMessageLookup := anObject
]

{ #category : #accessing }
LowtalkASTMessage >> compileTimeValue [
	^ compileTimeValue
]

{ #category : #accessing }
LowtalkASTMessage >> compileTimeValue: anObject [
	compileTimeValue := anObject
]

{ #category : #initialization }
LowtalkASTMessage >> initialize [
	super initialize.
	isCascaded := false
]

{ #category : #accessing }
LowtalkASTMessage >> isCascaded [
	^ isCascaded
]

{ #category : #accessing }
LowtalkASTMessage >> isCascaded: anObject [
	isCascaded := anObject
]

{ #category : #testing }
LowtalkASTMessage >> isMessageSend [
	^ true
]

{ #category : #printing }
LowtalkASTMessage >> printOn: aStream [
	aStream nextPutAll: '(send '; print: selector.
	receiver ifNotNil: [ aStream space; print: receiver].
	arguments do: [ :arg |
		aStream space; print: arg
	].
	aStream nextPut: $)
]

{ #category : #accessing }
LowtalkASTMessage >> receiver [
	^ receiver
]

{ #category : #accessing }
LowtalkASTMessage >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
LowtalkASTMessage >> selector [
	^ selector
]

{ #category : #accessing }
LowtalkASTMessage >> selector: anObject [
	selector := anObject
]

{ #category : #accessing }
LowtalkASTMessage >> specialMessageType [
	^ specialMessageType
]

{ #category : #accessing }
LowtalkASTMessage >> specialMessageType: anObject [
	specialMessageType := anObject
]
