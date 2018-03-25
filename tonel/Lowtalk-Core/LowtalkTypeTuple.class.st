Class {
	#name : #LowtalkTypeTuple,
	#superclass : #LowtalkType,
	#instVars : [
		'types'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #associating }
LowtalkTypeTuple >> , nextType [
	<compileTime>
	^ (LowtalkTypeTuple target: compilationTarget) types: types , { nextType }
]

{ #category : #associating }
LowtalkTypeTuple >> -> returnType [
	<compileTime>
	^ (LowtalkFunctionType target: compilationTarget)
		arguments: types;
		returnType: returnType;
		yourself
]

{ #category : #testing }
LowtalkTypeTuple >> isTupleType [
	^ true
]

{ #category : #accessing }
LowtalkTypeTuple >> types [
	^ types
]

{ #category : #accessing }
LowtalkTypeTuple >> types: anObject [
	types := anObject
]
