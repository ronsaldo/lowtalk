Class {
	#name : #LowtalkVariable,
	#superclass : #LowtalkBObject,
	#instVars : [
		'name',
		'isConstant',
		'compiler',
		'definitionNode'
	],
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #converting }
LowtalkVariable >> asLowtalkVariableReferenceFor: aCompiler [
	^ self
]

{ #category : #accessing }
LowtalkVariable >> compiler [
	^ compiler
]

{ #category : #accessing }
LowtalkVariable >> compiler: anObject [
	compiler := anObject
]

{ #category : #accessing }
LowtalkVariable >> definitionNode [
	^ definitionNode
]

{ #category : #accessing }
LowtalkVariable >> definitionNode: anObject [
	definitionNode := anObject
]

{ #category : #'code generation' }
LowtalkVariable >> emitSSAVariableLoadWith: codeGenerator builder: builder at: node [
	^ builder load: (self emitSSAVariableReferenceWith: codeGenerator builder: builder at: node)
]

{ #category : #'code generation' }
LowtalkVariable >> emitSSAVariableReferenceWith: codeGenerator builder: builder at: node [
	self subclassResponsibility
]

{ #category : #initialization }
LowtalkVariable >> initialize [
	super initialize.
	isConstant := false.
]

{ #category : #testing }
LowtalkVariable >> isCompileTimeVariable [
	^ false
]

{ #category : #accessing }
LowtalkVariable >> isConstant [
	^ isConstant
]

{ #category : #accessing }
LowtalkVariable >> isConstant: anObject [
	isConstant := anObject
]

{ #category : #testing }
LowtalkVariable >> isImageVariable [
	^ false
]

{ #category : #testing }
LowtalkVariable >> isInterpreterVariable [
	^ false
]

{ #category : #testing }
LowtalkVariable >> isMethodReceiverSlot [
	^ false
]

{ #category : #testing }
LowtalkVariable >> isVariable [
	^ true
]

{ #category : #accessing }
LowtalkVariable >> name [
	^ name
]

{ #category : #accessing }
LowtalkVariable >> name: anObject [
	name := anObject
]

{ #category : #accessing }
LowtalkVariable >> type [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkVariable >> value [
	self subclassResponsibility
]

{ #category : #accessing }
LowtalkVariable >> valueType [
	self subclassResponsibility
]
