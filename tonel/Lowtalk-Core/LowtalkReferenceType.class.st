Class {
	#name : #LowtalkReferenceType,
	#superclass : #LowtalkType,
	#instVars : [
		'referenced'
	],
	#classVars : [
		'ReferenceMessages'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #initialization }
LowtalkReferenceType class >> initialize [
	ReferenceMessages := Dictionary newFromPairs: #(
		address Address
	)
]

{ #category : #comparing }
LowtalkReferenceType >> = other [
	^ super = other and: [ referenced = other referenced ]
]

{ #category : #accessing }
LowtalkReferenceType >> alignment [
	^ compilationTarget pointerAlignment
]

{ #category : #converting }
LowtalkReferenceType >> asValueType [
	^ referenced asValueType
]

{ #category : #accessing }
LowtalkReferenceType >> buildSSAType [
	^ compilationTarget pointerTo: referenced ssaType
]

{ #category : #coercions }
LowtalkReferenceType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^true ].
	(referenced isArrayType and: [ targetType isPointerType and: [ referenced baseType = targetType pointed ] ]) ifTrue: [ ^ true ].
	^ referenced canBeImplicitlyConvertedTo: targetType
]

{ #category : #converting }
LowtalkReferenceType >> convertValue: value toType: targetType at: sendingNode [
	targetType isReferenceType ifFalse: [ 
		^ referenced convertValue: value value toType: targetType at: sendingNode
	].
	^ super convertValue: value toType: targetType at: sendingNode
]

{ #category : #coercions }
LowtalkReferenceType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithReference: self
]

{ #category : #comparing }
LowtalkReferenceType >> hash [
	^ super hash bitXor: referenced hash.
]

{ #category : #coercions }
LowtalkReferenceType >> irCoerceImplicitlyTo: targetType with: builder at: node [
	(referenced canBeImplicitlyConvertedTo: targetType) ifTrue: [
		builder send: #value.
		^ referenced irCoerceImplicitlyTo: targetType with: builder at: node
	].

	^ super irCoerceImplicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkReferenceType >> irConvertExplicitlyTo: targetType with: builder at: node [
	(referenced canBeExplicitlyConvertedTo: targetType) ifTrue: [
		builder send: #value.
		^ referenced irConvertExplicitlyTo: targetType with: builder at: node
	].

	^ super irConvertExplicitlyTo: targetType with: builder at: node
]

{ #category : #testing }
LowtalkReferenceType >> isReferenceType [
	^ true
]

{ #category : #printing }
LowtalkReferenceType >> printOn: aStream [
	aStream print: referenced; nextPutAll: ' ref'
]

{ #category : #accessing }
LowtalkReferenceType >> referenced [
	^ referenced
]

{ #category : #accessing }
LowtalkReferenceType >> referenced: anObject [
	referenced := anObject
]

{ #category : #accessing }
LowtalkReferenceType >> size [
	^ compilationTarget pointerSize
]

{ #category : #slots }
LowtalkReferenceType >> slotNamed: slotName ifAbsent: aBlock [
	^ referenced slotNamed: slotName ifAbsent: aBlock
]

{ #category : #slots }
LowtalkReferenceType >> slotNamed: slotName ifPresent: aBlock [
	^ referenced slotNamed: slotName ifPresent: aBlock
]

{ #category : #'special messages' }
LowtalkReferenceType >> specialMessageTypeForSelector: selector [
	ReferenceMessages at: selector ifPresent: [:type | ^ type ].
	^ super specialMessageTypeForSelector: selector
]

{ #category : #coercions }
LowtalkReferenceType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	(referenced canBeImplicitlyConvertedTo: targetType) ifTrue: [
		referenced isArrayType ifTrue: [ ^ value ].
		referenced isFunctionType ifTrue: [ ^ value ].
		(referenced isBlockType and: [ value isFunction ]) ifTrue: [ ^ value ].
		(referenced isBlockType and: [ value isCompiledMethodMetaData ]) ifTrue: [ ^ value sourceMethod ].
		
		^ referenced ssaCoerce: (builder load: value) implicitlyTo: targetType with: builder at: node
	].

	(referenced isArrayType and: [ targetType isPointerType and: [ referenced baseType = targetType pointed ] ]) ifTrue: [
		^ builder getReference: value element: (builder constInt: 0)
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkReferenceType >> ssaCoerceCVariadic: value with: builder at: node [
	self assert: referenced isReferenceType not.
	^ referenced ssaCoerceCVariadic: (builder load: value) with: builder at: node
]

{ #category : #coercions }
LowtalkReferenceType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	(referenced canBeExplicitlyConvertedTo: targetType) ifTrue: [
		referenced isFunctionType ifTrue: [ ^ value ].
		^ referenced ssaConvert: (builder load: value) explicitlyTo: targetType with: builder at: node
	].

	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]

{ #category : #accessing }
LowtalkReferenceType >> withoutReferences [
	^ referenced withoutReferences
]
