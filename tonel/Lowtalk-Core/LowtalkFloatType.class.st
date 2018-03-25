Class {
	#name : #LowtalkFloatType,
	#superclass : #LowtalkNumberType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #coercions }
LowtalkFloatType >> arithmeticCoerceWithFloat: otherType [
	^ self size > otherType size ifTrue: [ self ] ifFalse: [ otherType ]
]

{ #category : #coercions }
LowtalkFloatType >> arithmeticCoerceWithFloatLiteral: otherType [
	^ self
]

{ #category : #coercions }
LowtalkFloatType >> arithmeticCoerceWithInteger: otherType [
	^ self
]

{ #category : #coercions }
LowtalkFloatType >> arithmeticCoerceWithIntegerLiteral: otherType [
	^ self
]

{ #category : #testing }
LowtalkFloatType >> canBeExplicitlyConvertedTo: targetType [
	(super canBeExplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isIntegerType ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
LowtalkFloatType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	(targetType isFloatType and: [targetType size > self size]) ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
LowtalkFloatType >> canBeReinterpretedTo: targetType [
	^ targetType isIntegerType and: [targetType size = self size]
]

{ #category : #coercions }
LowtalkFloatType >> convertLiteralValue: value fromType: sourceType at: aNode [
	^ value asFloat
]

{ #category : #accessing }
LowtalkFloatType >> defaultSSAValueWith: builder [
	^ SLVMConstant type: self ssaType value: 0.0
]

{ #category : #accessing }
LowtalkFloatType >> defaultValue [
	^ 0.0
]

{ #category : #coercions }
LowtalkFloatType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithFloat: self
]

{ #category : #coercions }
LowtalkFloatType >> irConvertExplicitlyTo: targetType with: irBuilder at: node [
	targetType isIntegerType ifTrue: [ ^ irBuilder
		send: #asInteger;
		pushLiteral: targetType;
		send: #lowtalkTruncateLiteralValueWithType:
	].
	targetType isFloatType ifTrue: [
		^ irBuilder send: #asFloat;
		pushLiteral: targetType;
		send: #lowtalkTruncateLiteralValueWithType:
	].
	
	^ super irConvertExplicitlyTo: targetType with: irBuilder at: node
]

{ #category : #testing }
LowtalkFloatType >> isFloatType [
	^ true
]

{ #category : #'special messages' }
LowtalkFloatType >> operationSignature [
	^ #float
]

{ #category : #coercions }
LowtalkFloatType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isFloatType ifTrue: [ ^ builder floatingPointCast: value target: targetType ssaType ].	
	targetType isDynamicObjectType ifTrue: [ ^ builder floatToDynamicObjectCast: value target: targetType ssaType ].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkFloatType >> ssaCoerceCVariadic: value with: builder at: node [
	value type size = 4 ifTrue: [ ^ builder floatingPointCast: value target: builder compilationTarget double].
	^ value
]

{ #category : #coercions }
LowtalkFloatType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isFloatType ifTrue: [ ^ builder floatingPointCast: value target: targetType ssaType ].	
	targetType isIntegerType ifTrue: [ ^ builder floatToIntCast: value target: targetType ssaType ].
	targetType isDynamicObjectType ifTrue: [ ^ builder floatToDynamicObjectCast: value target: targetType ssaType ].
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
