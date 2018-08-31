Class {
	#name : #LowtalkEnvironmentWrapper,
	#superclass : #LowtalkAbstractEnvironment,
	#instVars : [
		'environment'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkEnvironmentWrapper >> environment [
	^ environment
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> environment: anObject [
	environment := anObject
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> lookSymbol: symbol [
	^ environment lookSymbol: symbol
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> lookSymbol: symbol ifAbsent: aBlock [
	^ environment lookSymbol: symbol ifAbsent: aBlock
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> lookSymbol: symbol ifAbsentPut: aBlock [
	^ environment lookSymbol: symbol ifAbsentPut: aBlock
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> lookSymbol: symbol ifPresent: aBlock [
	^ environment lookSymbol: symbol ifPresent: aBlock
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> namespaceEnvironment [
	^ environment namespaceEnvironment
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> receiver [
	environment isNamespace ifTrue: [ ^ environment receiver ].
	^ super receiver
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> receiverType [
	environment isNamespace ifTrue: [ ^ environment receiverType ].
	^ super receiverType
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> setSymbol: aSymbol value: aValue [
	^ environment setSymbol: aSymbol value: aValue
]

{ #category : #accessing }
LowtalkEnvironmentWrapper >> setSymbol: aSymbol value: aValue ifPresent: aBlock [
	^ environment setSymbol: aSymbol value: aValue ifPresent: aBlock
]
