Class {
	#name : #LowtalkArrayInstance,
	#superclass : #LowtalkBObject,
	#instVars : [
		'type',
		'slots'
	],
	#category : 'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkArrayInstance >> at: index [
	<compileTime>
	^ LowtalkArraySlotPointer new array: self; index: index; type: type baseType
]

{ #category : #accessing }
LowtalkArrayInstance >> at: index put: value [
	<compileTime>
	slots at: index put: value.
	^ value
]

{ #category : #accessing }
LowtalkArrayInstance >> slotValues [
	^ slots
]

{ #category : #accessing }
LowtalkArrayInstance >> slots [
	^ slots
]

{ #category : #accessing }
LowtalkArrayInstance >> slots: anObject [
	slots := anObject
]

{ #category : #accessing }
LowtalkArrayInstance >> type [
	^ type
]

{ #category : #accessing }
LowtalkArrayInstance >> type: anObject [
	type := anObject
]
