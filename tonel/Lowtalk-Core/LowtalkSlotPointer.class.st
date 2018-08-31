Class {
	#name : #LowtalkSlotPointer,
	#superclass : #LowtalkBObject,
	#instVars : [
		'description',
		'object',
		'type'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #converting }
LowtalkSlotPointer >> asLowtalkVariableReferenceFor: aCompiler [
	^ self
]

{ #category : #accessing }
LowtalkSlotPointer >> description [
	^ description
]

{ #category : #accessing }
LowtalkSlotPointer >> description: anObject [
	description := anObject
]

{ #category : #accessing }
LowtalkSlotPointer >> object [
	^ object
]

{ #category : #accessing }
LowtalkSlotPointer >> object: anObject [
	object := anObject
]

{ #category : #evaluating }
LowtalkSlotPointer >> type [
	^ type ifNil: [type := self valueType ref]
]

{ #category : #evaluating }
LowtalkSlotPointer >> value [
	^ object slots at: description index + 1
]

{ #category : #evaluating }
LowtalkSlotPointer >> value: newValue [
	^ object slots at: description index + 1 put: newValue
]

{ #category : #evaluating }
LowtalkSlotPointer >> valueType [
	^ description type
]
