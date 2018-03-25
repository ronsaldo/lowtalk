Class {
	#name : #LowtalkFloatLiteralType,
	#superclass : #LowtalkNumberLiteralType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #coercions }
LowtalkFloatLiteralType >> arithmeticCoerceWithFloat: otherType [
	^ otherType
]

{ #category : #converting }
LowtalkFloatLiteralType >> asValueType [
	"TODO: Try to select a more appropiate type."
	^ LowtalkTypeFloat64 new
]

{ #category : #testing }
LowtalkFloatLiteralType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].

	^ false
]

{ #category : #coercions }
LowtalkFloatLiteralType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithFloatLiteral: self
]

{ #category : #accessing }
LowtalkFloatLiteralType >> name [
	^ #_FloatLiteral
]

{ #category : #coercions }
LowtalkFloatLiteralType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asFloat.
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkFloatLiteralType >> ssaCoerceCVariadic: value with: builder at: node [
	^ builder constDouble: value
]

{ #category : #coercions }
LowtalkFloatLiteralType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asFloat.
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
