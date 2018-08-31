Class {
	#name : #LowtalkImageVariable,
	#superclass : #LowtalkVariable,
	#instVars : [
		'type',
		'binding',
		'ssaValue'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkImageVariable >> binding [
	^ binding
]

{ #category : #accessing }
LowtalkImageVariable >> binding: anObject [
	binding := anObject
]

{ #category : #'code generation' }
LowtalkImageVariable >> buildSSAValue [
	ssaValue := SLVMGlobalVariable module: compiler ssaModule name: name valueType: self valueType ssaType storage: SLVMType genericStorage.
	ssaValue makePrivate;
		propertyAt: #omitDebugInformation put: true;
		propertyAt: #binding put: self capturedBinding
]

{ #category : #accessing }
LowtalkImageVariable >> capturedBinding [
	^ self binding
]

{ #category : #'code generation' }
LowtalkImageVariable >> emitSSAVariableReferenceWith: codeGenerator builder: builder at: node [
	^ self ssaValue
]

{ #category : #testing }
LowtalkImageVariable >> isImageVariable [
	^ true
]

{ #category : #'code generation' }
LowtalkImageVariable >> ssaValue [
	ssaValue ifNil: [ self buildSSAValue ].
	^ ssaValue
]

{ #category : #accessing }
LowtalkImageVariable >> type [
	^ type
]

{ #category : #accessing }
LowtalkImageVariable >> type: anObject [
	type := anObject
]

{ #category : #accessing }
LowtalkImageVariable >> value [
	^ binding value asLowtalkImportedValueWith: compiler
]

{ #category : #accessing }
LowtalkImageVariable >> value: aValue [
	binding value: aValue
]

{ #category : #accessing }
LowtalkImageVariable >> valueType [
	self flag: 'TODO: Check whether this is a value type or a reference type'.
	^ type
]
