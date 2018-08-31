Class {
	#name : #LowtalkArrayType,
	#superclass : #LowtalkType,
	#instVars : [
		'baseType',
		'elements'
	],
	#classVars : [
		'ArrayMessages'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #initialization }
LowtalkArrayType class >> initialize [
	ArrayMessages := Dictionary newFromPairs: #(
		value PointerDeReference
		at: PointerDeReference
		basicAt: PointerDeReference
		atOffset: PointerDeReference
		basicAtOffset: PointerDeReference
		
		value: PointerElementAssignment
		
		atOffset:put: PointerElementAssignment
		basicAtOffset:put: PointerElementAssignment
	)
]

{ #category : #accessing }
LowtalkArrayType >> alignment [
	^ baseType alignment
]

{ #category : #accessing }
LowtalkArrayType >> baseType [
	^ baseType
]

{ #category : #accessing }
LowtalkArrayType >> baseType: anObject [
	baseType := anObject
]

{ #category : #accessing }
LowtalkArrayType >> buildSSAType [
	^ SLVMArrayType baseType: baseType ssaType elements: elements
]

{ #category : #converting }
LowtalkArrayType >> convertValue: value toSSAConstantWith: compiler [
	| convertedSlots |
	convertedSlots := value slotValues collect: [ :slot | baseType convertValue: slot toSSAConstantWith: compiler].
	^ SLVMConstant array: self ssaType slots: convertedSlots
]

{ #category : #accessing }
LowtalkArrayType >> defaultValue [
	baseType isIntegerType ifTrue: [ 
		baseType size = 1 ifTrue: [ ^ LowtalkArrayInstance new type: self; slots: (ByteArray new: elements) ].
	].

	^ LowtalkArrayInstance new
		type: self;
		slots: ((1 to: elements) collect: [ :index | baseType defaultValue ]);
		yourself
]

{ #category : #accessing }
LowtalkArrayType >> elements [
	^ elements
]

{ #category : #accessing }
LowtalkArrayType >> elements: anObject [
	elements := anObject
]

{ #category : #testing }
LowtalkArrayType >> isArrayType [
	^ true
]

{ #category : #accessing }
LowtalkArrayType >> size [
	^ baseType size * elements
]

{ #category : #'special messages' }
LowtalkArrayType >> specialMessageTypeForSelector: selector [
	ArrayMessages at: selector ifPresent: [:type | ^ type ].
	^ super specialMessageTypeForSelector: selector
]
