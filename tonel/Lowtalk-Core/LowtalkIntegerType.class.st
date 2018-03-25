Class {
	#name : #LowtalkIntegerType,
	#superclass : #LowtalkNumberType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #coercions }
LowtalkIntegerType >> arithmeticCoerceWithFloat: otherType [
	^ otherType
]

{ #category : #coercions }
LowtalkIntegerType >> arithmeticCoerceWithInteger: otherType [
	(self size <= 4 and: [otherType size <= 4]) ifTrue: [ 
		"Signed/Unsigned mismatch."
		(self size = 4 and: [ otherType size = 4 ]) ifTrue: [
			^ self isSigned ifTrue: [ self ] ifFalse: [ otherType ]
		].
		^ LowtalkTypeInt32 target: compilationTarget.
	].

	"Increase the size"
	(self size <= 8 and: [ otherType size <= 8 ]) ifTrue: [ 
		^ (self isSigned or: [otherType isSigned]) ifTrue: [ LowtalkTypeInt64 target: compilationTarget  ] ifFalse: [ LowtalkTypeUInt64 target: compilationTarget ]
	].
	

	^ super arithmeticCoerceWithInteger: otherType
]

{ #category : #coercions }
LowtalkIntegerType >> arithmeticCoerceWithIntegerLiteral: otherType [
	self flag: 'Avoid creating new objects.'.
	^ self size <= 4 ifTrue: [ 
		self isSigned ifTrue: [ LowtalkTypeInt32 target: compilationTarget ] ifFalse: [ LowtalkTypeUInt32 target: compilationTarget ]
	] ifFalse: [ 
		self isSigned ifTrue: [ LowtalkTypeInt64 target: compilationTarget ] ifFalse: [ LowtalkTypeUInt64 target: compilationTarget ]
	].
]

{ #category : #converting }
LowtalkIntegerType >> asIntegerTypeAt: node [
	"Nothing required"
]

{ #category : #converting }
LowtalkIntegerType >> canBeExplicitlyConvertedTo: targetType [
	(super canBeExplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isIntegerType ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].
	(targetType isPointerType and: [ targetType size = self size ]) ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
LowtalkIntegerType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isFloatType ifTrue: [ ^ true ].
	(targetType isIntegerType and: [ targetType size >= self size ]) ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
LowtalkIntegerType >> canBeReinterpretedTo: targetType [
	^ targetType isPointerType or:
	[ targetType isDynamicObjectType or:
	[ targetType isSpecificDynamicObjectType or:
	[ (targetType isIntegerType and: [targetType size = self size]) or:
	[ (targetType isFloatType and: [targetType size = self size]) ] ] ] ]
]

{ #category : #converting }
LowtalkIntegerType >> convertLiteralValue: value fromType: sourceType at: aNode [
	^ self truncateLiteralValue: value asInteger at: aNode
]

{ #category : #accessing }
LowtalkIntegerType >> defaultSSAValueWith: builder [
	^ SLVMConstant type: self ssaType value: 0
]

{ #category : #accessing }
LowtalkIntegerType >> defaultValue [
	^ 0
]

{ #category : #coercions }
LowtalkIntegerType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithInteger: self
]

{ #category : #coercions }
LowtalkIntegerType >> irConvertExplicitlyTo: targetType with: irBuilder at: node [
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
LowtalkIntegerType >> isIntegerType [
	^ true
]

{ #category : #testing }
LowtalkIntegerType >> isSigned [
	^ true
]

{ #category : #testing }
LowtalkIntegerType >> isUnsigned [
	^ self isSigned not
]

{ #category : #'special messages' }
LowtalkIntegerType >> operationSignature [
	^ self isSigned ifTrue: [ #int ] ifFalse: [ #uint ]
]

{ #category : #coercions }
LowtalkIntegerType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isIntegerType ifTrue: [ ^ builder intCast: value target: targetType ssaType ].
	targetType isFloatType ifTrue: [ ^ builder intToFloatCast: value target: targetType ssaType ].	
	targetType isDynamicObjectType ifTrue: [ ^ builder intToDynamicObjectCast: value target: targetType ssaType ].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkIntegerType >> ssaCoerceCVariadic: value with: builder at: node [
	^ value
]

{ #category : #coercions }
LowtalkIntegerType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isIntegerType ifTrue: [ ^ builder intCast: value target: targetType ssaType ].
	targetType isFloatType ifTrue: [ ^ builder intToFloatCast: value target: targetType ssaType ].	
	(targetType isPointerType and: [ self size = targetType size ]) ifTrue: [ 
		^ builder bitCast: value target: targetType ssaType
	].	
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]

{ #category : #converting }
LowtalkIntegerType >> truncateLiteralValue: value at: aNode [
	| bitMask signBit bitCount |
	bitCount := self size * 8.
	bitMask := (1 << bitCount) - 1.
	^ self isSigned ifTrue: [
		signBit := (1<< (bitCount - 1)).
		(value bitAnd: bitMask - signBit) - (value bitAnd: signBit)
	] ifFalse: [ value bitAnd: bitMask ]
]
