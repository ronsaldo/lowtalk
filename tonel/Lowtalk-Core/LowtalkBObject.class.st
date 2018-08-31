Class {
	#name : #LowtalkBObject,
	#superclass : #Object,
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #testing }
LowtalkBObject >> isArgument [
	^ false
]

{ #category : #testing }
LowtalkBObject >> isCompileTimePointer [
	^ false
]

{ #category : #testing }
LowtalkBObject >> isEnvironment [
	^ false
]

{ #category : #testing }
LowtalkBObject >> isInlineArgument [
	^ false
]

{ #category : #testing }
LowtalkBObject >> isLocalVariable [
	^ false
]

{ #category : #testing }
LowtalkBObject >> isLowtalkBObject [
	^ true
]

{ #category : #testing }
LowtalkBObject >> isMethodVariable [
	^ false
]

{ #category : #testing }
LowtalkBObject >> isObjectInstance [
	^ false
]

{ #category : #testing }
LowtalkBObject >> isStructureInstance [
	^ false
]

{ #category : #testing }
LowtalkBObject >> isVariable [
	^ false
]

{ #category : #'as yet unclassified' }
LowtalkBObject >> mangleSelector: aSelector [
	^ ByteString streamContents: [ :out |
		aSelector do: [ :char |
			(char isAlphaNumeric or: [ char = $_ ]) ifTrue: [ 
				out nextPut: char
			] ifFalse: [
				char nextPutAll: '_x' ; nextPutAll: char printStringHex
			].
		]
	]
]
