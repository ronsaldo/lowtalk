Class {
	#name : #LowtalkMethodVariable,
	#superclass : #LowtalkVariable,
	#instVars : [
		'method',
		'ssaValue'
	],
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #'code generation' }
LowtalkMethodVariable >> emitSSAVariableReferenceWith: codeGenerator builder: builder at: node [
	self assert: ssaValue isNotNil.
	method ~~ codeGenerator method ifTrue: [
		^ codeGenerator captureInClosure: ssaValue
	].

	^ ssaValue
]

{ #category : #testing }
LowtalkMethodVariable >> isMethodVariable [
	^ true
]

{ #category : #accessing }
LowtalkMethodVariable >> method [
	^ method
]

{ #category : #accessing }
LowtalkMethodVariable >> method: anObject [
	method := anObject
]

{ #category : #accessing }
LowtalkMethodVariable >> ssaValue [
	^ ssaValue
]

{ #category : #accessing }
LowtalkMethodVariable >> ssaValue: anObject [
	ssaValue := anObject
]
