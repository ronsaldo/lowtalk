Class {
	#name : #LowtalkImageEnvironment,
	#superclass : #LowtalkAbstractEnvironment,
	#instVars : [
		'environment'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkImageEnvironment >> environment [
	^ environment
]

{ #category : #accessing }
LowtalkImageEnvironment >> environment: anObject [
	environment := anObject
]

{ #category : #testing }
LowtalkImageEnvironment >> isNamespace [
	^ true
]

{ #category : #accessing }
LowtalkImageEnvironment >> lookSymbol: symbol ifPresent: aBlock [
	^ environment associationAt: symbol ifPresent: aBlock
]
