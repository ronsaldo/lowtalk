Class {
	#name : #LowtalkVariableSlot,
	#superclass : #LowtalkBObject,
	#instVars : [
		'value'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkVariableSlot >> value [
	^ value
]

{ #category : #accessing }
LowtalkVariableSlot >> value: anObject [
	value := anObject
]
