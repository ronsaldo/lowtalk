Class {
	#name : #LowtalkMethodArgument,
	#superclass : #LowtalkMethodLocalVariable,
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #'code generation' }
LowtalkMethodArgument >> emitSSAVariableLoadWith: codeGenerator builder: builder at: node [
	self assert: ssaValue isNotNil.
	method ~~ codeGenerator method ifTrue: [
		^ codeGenerator captureInClosure: ssaValue
	].

	^ ssaValue
]

{ #category : #'code generation' }
LowtalkMethodArgument >> emitSSAVariableReferenceWith: codeGenerator builder: builder at: node [
	valueType isReferenceType ifTrue: [ ^ self emitSSAVariableLoadWith: codeGenerator builder: builder at: node ].
	self error: 'Cannot get reference to argument'
]

{ #category : #testing }
LowtalkMethodArgument >> isArgument [
	^ true
]

{ #category : #accessing }
LowtalkMethodArgument >> valueType: aValueType [
	valueType := aValueType.
	type := aValueType.
]
