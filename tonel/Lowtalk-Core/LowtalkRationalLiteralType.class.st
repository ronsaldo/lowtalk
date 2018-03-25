Class {
	#name : #LowtalkRationalLiteralType,
	#superclass : #LowtalkNumberLiteralType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #converting }
LowtalkRationalLiteralType >> asValueType [
	"TODO: Try to select a more appropiate type."
	^ LowtalkTypeFloat64 new
]

{ #category : #testing }
LowtalkRationalLiteralType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].

	^ false
]

{ #category : #accessing }
LowtalkRationalLiteralType >> name [
	^ #_RationalLiteral
]

{ #category : #coercions }
LowtalkRationalLiteralType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asFloat.
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkRationalLiteralType >> ssaCoerceCVariadic: value with: builder at: node [
	^ builder constDouble: value asFloat
]

{ #category : #coercions }
LowtalkRationalLiteralType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asFloat.
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
