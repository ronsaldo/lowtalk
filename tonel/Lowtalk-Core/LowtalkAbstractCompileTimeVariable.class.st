Class {
	#name : #LowtalkAbstractCompileTimeVariable,
	#superclass : #LowtalkInterpreterVariable,
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #'code generation' }
LowtalkAbstractCompileTimeVariable >> emitSSAVariableLoadWith: codeGenerator builder: builder at: node [
	^ compiler convertDynamicObjectSSAConstant: self value.
]

{ #category : #'code generation' }
LowtalkAbstractCompileTimeVariable >> emitSSAVariableReferenceWith: codeGenerator builder: builder at: node [
	^ compiler convertCapturedCompileTimeVariable: self
]

{ #category : #testing }
LowtalkAbstractCompileTimeVariable >> isCompileTimeVariable [
	^ true
]
