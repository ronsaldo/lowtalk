Class {
	#name : #LowtalkBoxedObjectType,
	#superclass : #LowtalkSpecificDynamicObjectType,
	#instVars : [
		'boxed'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #converting }
LowtalkBoxedObjectType >> asConstantValueType [
	^ boxed
]

{ #category : #accessing }
LowtalkBoxedObjectType >> boxed [
	^ boxed
]

{ #category : #accessing }
LowtalkBoxedObjectType >> boxed: anObject [
	boxed := anObject
]

{ #category : #testing }
LowtalkBoxedObjectType >> isBoxedType [
	^ true
]

{ #category : #accessing }
LowtalkBoxedObjectType >> name [
	^ boxed name , ' boxed'
]
