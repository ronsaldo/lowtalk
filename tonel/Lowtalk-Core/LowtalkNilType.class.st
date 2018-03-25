Class {
	#name : #LowtalkNilType,
	#superclass : #LowtalkPrimitiveType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkNilType >> alignment [
	^ compilationTarget pointerAlignment 
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithBoolean: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithBooleanLiteral: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithCharacter: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithFloat: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithFloatLiteral: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithInteger: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithIntegerLiteral: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithPointer: pointerType [
	^ pointerType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithStringLiteral: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkNilType >> arithmeticCoerceWithSymbolLiteral: otherType [
	^ otherType
]

{ #category : #converting }
LowtalkNilType >> asValueType [
	^ LowtalkDynamicObjectType target: compilationTarget
]

{ #category : #converting }
LowtalkNilType >> asValueTypeKeepVoid [
	^ self
]

{ #category : #testing }
LowtalkNilType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isPointerType ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	targetType isVoidType ifTrue: [ ^ true ].
	
	^ false
]

{ #category : #accessing }
LowtalkNilType >> defaultValue [
	^ nil
]

{ #category : #coercions }
LowtalkNilType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithNilType: self
]

{ #category : #coercions }
LowtalkNilType >> irCoerceImplicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: builder at: node
]

{ #category : #testing }
LowtalkNilType >> isNilType [
	^ true
]

{ #category : #accessing }
LowtalkNilType >> name [
	^ #_Nil
]

{ #category : #accessing }
LowtalkNilType >> size [
	^ compilationTarget pointerSize
]

{ #category : #coercions }
LowtalkNilType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType = self ifTrue: [ ^ value ].
	targetType isVoidType ifTrue: [ ^ value ].
	^ targetType defaultSSAValueWith: builder
]

{ #category : #coercions }
LowtalkNilType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType = self ifTrue: [ ^ value ].
	targetType isVoidType ifTrue: [ ^ value ].
	^ targetType defaultSSAValueWith: builder
]
