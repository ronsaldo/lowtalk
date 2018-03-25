Class {
	#name : #LowtalkStringLiteralType,
	#superclass : #LowtalkLiteralType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #converting }
LowtalkStringLiteralType >> asValueType [
	^ LowtalkDynamicObjectType target: compilationTarget
]

{ #category : #testing }
LowtalkStringLiteralType >> canBeImplicitlyConvertedTo: targetType [
	| pointed |
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	
	"CStrings"
	targetType isPointerType ifTrue: [ 
		pointed := targetType pointed.
		(pointed isIntegerType and: [ pointed size = 1 ]) ifTrue: [ ^ true ].
	].

	^ false
]

{ #category : #converting }
LowtalkStringLiteralType >> convertLiteralValue: value fromType: sourceType at: aNode [
	^ value asString
]

{ #category : #accessing }
LowtalkStringLiteralType >> defaultSSAValueWith: builder [
	^ builder addDynamicLiteral: nil
]

{ #category : #coercions }
LowtalkStringLiteralType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithStringLiteral: self
]

{ #category : #accessing }
LowtalkStringLiteralType >> name [
	^ #_StringLiteral
]

{ #category : #testing }
LowtalkStringLiteralType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	| pointed |
	"CStrings"
	targetType isPointerType ifTrue: [ 
		pointed := targetType pointed.
		(pointed isIntegerType and: [ pointed size = 1 ]) ifTrue: [
			^ builder constCString: value
		].
	].

	targetType isDynamicObjectType ifTrue: [ 
		^ builder addDynamicLiteral: value
	].

	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #testing }
LowtalkStringLiteralType >> ssaCoerceCVariadic: value with: builder at: node [
	^ builder constCString: value
]

{ #category : #testing }
LowtalkStringLiteralType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	| pointed |
	"CStrings"
	targetType isPointerType ifTrue: [ 
		pointed := targetType pointed.
		(pointed isIntegerType and: [ pointed size = 1 ]) ifTrue: [
			^ builder constCString: value
		].
	].

	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
