Class {
	#name : #LowtalkIntegerLiteralType,
	#superclass : #LowtalkNumberLiteralType,
	#category : #'Lowtalk-Core-Types'
}

{ #category : #coercions }
LowtalkIntegerLiteralType >> arithmeticCoerceWithCharacter: otherType [
	^ LowtalkTypeInt32 target: compilationTarget
]

{ #category : #coercions }
LowtalkIntegerLiteralType >> arithmeticCoerceWithInteger: otherType [
	otherType size < 4 ifTrue: [ ^ LowtalkTypeInt32 target: compilationTarget  ].
	^ otherType
]

{ #category : #accessing }
LowtalkIntegerLiteralType >> asIntegerTypeAt: node [
	"Nothing required"
]

{ #category : #converting }
LowtalkIntegerLiteralType >> asValueType [
	"TODO: Try to select a more appropiate type."
	^ LowtalkTypeInt32 target: compilationTarget
]

{ #category : #coercions }
LowtalkIntegerLiteralType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isIntegerType ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].

	^ false
]

{ #category : #coercions }
LowtalkIntegerLiteralType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithIntegerLiteral: self
]

{ #category : #accessing }
LowtalkIntegerLiteralType >> name [
	^ #_IntegerLiteral
]

{ #category : #coercions }
LowtalkIntegerLiteralType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isIntegerType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value.
	].
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asFloat.
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkIntegerLiteralType >> ssaCoerceCVariadic: value with: builder at: node [
	^ builder constInt: value
]

{ #category : #coercions }
LowtalkIntegerLiteralType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isIntegerType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value.
	].
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asFloat.
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
