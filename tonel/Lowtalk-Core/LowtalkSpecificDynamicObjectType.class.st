Class {
	#name : #LowtalkSpecificDynamicObjectType,
	#superclass : #LowtalkType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkSpecificDynamicObjectType >> alignment [
	^ compilationTarget pointerSize
]

{ #category : #converting }
LowtalkSpecificDynamicObjectType >> asDefaultReturnTypeWith: aCompiler [
	^ aCompiler objectType
]

{ #category : #accessing }
LowtalkSpecificDynamicObjectType >> buildSSAType [
	^ compilationTarget dynamicObjectType
]

{ #category : #testing }
LowtalkSpecificDynamicObjectType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
LowtalkSpecificDynamicObjectType >> canBeReinterpretedTo: targetType [
	^ targetType isPointerType or:
	[ targetType isDynamicObjectType or:
	[ targetType isSpecificDynamicObjectType or:
	[ targetType isIntegerType and: [targetType size = self size ] ] ] ]
]

{ #category : #converting }
LowtalkSpecificDynamicObjectType >> convertValue: value toSSAConstantWith: compiler [
	self halt
]

{ #category : #converting }
LowtalkSpecificDynamicObjectType >> convertValue: value toType: targetType at: sendingNode [
	targetType isDynamicObjectType ifTrue: [ ^ value ].
	^ super convertValue: value toType: targetType at: sendingNode
]

{ #category : #accessing }
LowtalkSpecificDynamicObjectType >> defaultSSAValueWith: builder [
	^ builder addDynamicLiteral: nil
]

{ #category : #accessing }
LowtalkSpecificDynamicObjectType >> defaultValue [
	^ nil
]

{ #category : #coercions }
LowtalkSpecificDynamicObjectType >> dispatchArithmeticCoerceWith: otherType [
	^ (LowtalkDynamicObjectType target: compilationTarget) arithmeticCoerceWith: otherType
]

{ #category : #coercions }
LowtalkSpecificDynamicObjectType >> irCoerceImplicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: builder at: node
]

{ #category : #testing }
LowtalkSpecificDynamicObjectType >> isAnyDynamicObjectType [
	^ true
]

{ #category : #testing }
LowtalkSpecificDynamicObjectType >> isSpecificDynamicObjectType [
	^ true
]

{ #category : #testing }
LowtalkSpecificDynamicObjectType >> size [
	^ compilationTarget pointerSize
]

{ #category : #'special messages' }
LowtalkSpecificDynamicObjectType >> specialMessageTypeForSelector: selector [
	DynamicObjectSpecialMessages at: selector ifPresent: [ :type | ^ type ].
	^ super specialMessageTypeForSelector: selector
]

{ #category : #coercions }
LowtalkSpecificDynamicObjectType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [ ^ value ].
	targetType isSpecialGenericType ifTrue: [ ^ value ].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]
