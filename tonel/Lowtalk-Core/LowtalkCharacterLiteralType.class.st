Class {
	#name : #LowtalkCharacterLiteralType,
	#superclass : #LowtalkLiteralType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #coercions }
LowtalkCharacterLiteralType >> arithmeticCoerceWithCharacter: otherType [
	^ self
]

{ #category : #converting }
LowtalkCharacterLiteralType >> asValueType [
	"TODO: Try to select a more appropiate type."
	^ LowtalkTypeInt32 target: compilationTarget
]

{ #category : #testing }
LowtalkCharacterLiteralType >> canBeExplicitlyConvertedTo: targetType [
	targetType isIntegerType ifTrue: [ ^ true ].
	^ super canBeExplicitlyConvertedTo: targetType
]

{ #category : #coercions }
LowtalkCharacterLiteralType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithCharacter: self
]

{ #category : #accessing }
LowtalkCharacterLiteralType >> name [
	^ #_CharacterLiteral
]

{ #category : #coercions }
LowtalkCharacterLiteralType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isIntegerType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asInteger.
	].
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asInteger asFloat.
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkCharacterLiteralType >> ssaCoerceCVariadic: value with: builder at: node [
	^ builder constInt: value asInteger
]

{ #category : #coercions }
LowtalkCharacterLiteralType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isIntegerType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asInteger.
	].
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asInteger asFloat.
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
