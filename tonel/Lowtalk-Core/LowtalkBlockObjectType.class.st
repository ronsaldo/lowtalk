Class {
	#name : #LowtalkBlockObjectType,
	#superclass : #LowtalkSpecificDynamicObjectType,
	#instVars : [
		'functionType'
	],
	#category : #'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkBlockObjectType >> arguments [
	^ functionType arguments
]

{ #category : #converting }
LowtalkBlockObjectType >> asConstantValueType [
	^ functionType
]

{ #category : #accessing }
LowtalkBlockObjectType >> functionType [
	^ functionType
]

{ #category : #accessing }
LowtalkBlockObjectType >> functionType: anObject [
	functionType := anObject
]

{ #category : #testing }
LowtalkBlockObjectType >> isBlockType [
	^ true
]

{ #category : #accessing }
LowtalkBlockObjectType >> name [
	^ functionType name , ' block'
]

{ #category : #accessing }
LowtalkBlockObjectType >> returnType [
	^ functionType returnType
]

{ #category : #'special messages' }
LowtalkBlockObjectType >> specialMessageTypeForSelector: selector [
	BlockSpecialMessages at: selector ifPresent: [ :type | ^ type ].
	^ super specialMessageTypeForSelector: selector
]

{ #category : #coercions }
LowtalkBlockObjectType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	value type isPointerType ifTrue: [
		self assert: targetType isDynamicObjectType.
		^ builder closureToDynamicObject: value target: targetType ssaType
	].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]
