Class {
	#name : #LowtalkObjectSlotsType,
	#superclass : #LowtalkSpecificDynamicObjectType,
	#instVars : [
		'objectType',
		'accessMode'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkObjectSlotsType >> accessMode [
	^ accessMode
]

{ #category : #accessing }
LowtalkObjectSlotsType >> accessMode: anObject [
	accessMode := anObject
]

{ #category : #testing }
LowtalkObjectSlotsType >> isObjectSlots [
	^ true
]

{ #category : #methods }
LowtalkObjectSlotsType >> methodSignatureForSelector: selector environment: anEnvironment [
	^ objectType compiler voidType
]

{ #category : #accessing }
LowtalkObjectSlotsType >> objectType [
	^ objectType
]

{ #category : #accessing }
LowtalkObjectSlotsType >> objectType: anObject [
	objectType := anObject
]

{ #category : #printing }
LowtalkObjectSlotsType >> printOn: aStream [
	aStream print: objectType; space; nextPutAll: accessMode
]

{ #category : #slots }
LowtalkObjectSlotsType >> slotNamed: slotName [
	^ objectType slotNamed: slotName
]

{ #category : #slots }
LowtalkObjectSlotsType >> slotNamed: slotName ifAbsent: aBlock [
	^ objectType slots at: slotName ifAbsent: aBlock
	
]

{ #category : #slots }
LowtalkObjectSlotsType >> slotNamed: slotName ifPresent: aBlock [
	^ objectType slots at: slotName ifPresent: aBlock
	
]

{ #category : #slots }
LowtalkObjectSlotsType >> specialMessageTypeForSelector: selector [
	self slotNamed: selector ifPresent: [ :slot | ^ slot specialSelectorType ].
	selector last = $: ifTrue: [ 
		self slotNamed: selector allButLast ifPresent: [ :slot | ^ slot setterSpecialSelectorType ].
	].

	^ super specialMessageTypeForSelector: selector

]
