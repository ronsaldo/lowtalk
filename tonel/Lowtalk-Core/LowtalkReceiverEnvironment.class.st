Class {
	#name : #LowtalkReceiverEnvironment,
	#superclass : #LowtalkAbstractEnvironment,
	#instVars : [
		'receiverType',
		'receiver'
	],
	#category : #'Lowtalk-Core-Environment'
}

{ #category : #accessing }
LowtalkReceiverEnvironment >> convertSlot: slot [
	^ receiver pointerForSlotDescription: slot
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> lookSymbol: symbol [
	^ self lookSymbol: symbol ifAbsent: [ self error: 'Symbol not found.' ]
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> lookSymbol: symbol ifAbsent: aBlock [
	^ self convertSlot: (receiverType slotNamed: symbol ifAbsent: aBlock)
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> lookSymbol: symbol ifAbsentPut: aBlock [
	self shouldNotImplement
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> lookSymbol: symbol ifPresent: aBlock [
	receiverType slotNamed: symbol ifPresent: [:slot |
		aBlock value: (self convertSlot: slot)
	]
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> namespaceEnvironment [
	^ parent namespaceEnvironment
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> receiver [
	^ receiver
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> receiver: anObject [
	receiver := anObject
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> receiverType [
	^ receiverType
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> receiverType: anObject [
	receiverType := anObject
]

{ #category : #accessing }
LowtalkReceiverEnvironment >> receiverTypeOr: defaultType [
	^ receiverType
]
