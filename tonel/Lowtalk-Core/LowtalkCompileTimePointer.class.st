Class {
	#name : #LowtalkCompileTimePointer,
	#superclass : #LowtalkBObject,
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #testing }
LowtalkCompileTimePointer >> isCompileTimePointer [
	^ true
]

{ #category : #'as yet unclassified' }
LowtalkCompileTimePointer >> toSSAPointerConstantWith: aCompiler [
	self subclassResponsibility
]
