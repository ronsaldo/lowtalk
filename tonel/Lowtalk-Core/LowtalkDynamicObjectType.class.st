Class {
	#name : #LowtalkDynamicObjectType,
	#superclass : #LowtalkSingletonType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #accessing }
LowtalkDynamicObjectType >> alignment [
	^ compilationTarget pointerSize
]

{ #category : #accessing }
LowtalkDynamicObjectType >> buildSSAType [
	^ compilationTarget dynamicObjectType 
]

{ #category : #testing }
LowtalkDynamicObjectType >> canBeExplicitlyConvertedTo: targetType [
	(super canBeExplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isSpecificDynamicObjectType ifTrue: [ ^ true ].
	targetType isPrimitiveType ifTrue: [ ^ true ].
	targetType isPointerType ifTrue: [ ^ true ].
	targetType isStructureType ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
LowtalkDynamicObjectType >> canBeReinterpretedTo: targetType [
	^ targetType isPointerType or:
	[ targetType isDynamicObjectType or:
	[ targetType isSpecificDynamicObjectType or:
	[ targetType isIntegerType and: [targetType size = self size ] ] ] ]
]

{ #category : #converting }
LowtalkDynamicObjectType >> convertLiteralValue: value fromType: sourceType at: aNode [
	^ value
]

{ #category : #converting }
LowtalkDynamicObjectType >> convertValue: value toSSAConstantWith: compiler [
	^ compiler convertDynamicObjectSSAConstant: value
]

{ #category : #converting }
LowtalkDynamicObjectType >> convertValue: value toType: targetType at: aNode [
	targetType isSpecificDynamicObjectType ifTrue: [
		(targetType isValueConforming: value) ifFalse: [
			(aNode semanticError: 'Cannot convert value of type {1} to type {2}.') format: { self name . targetType name }.
		].
		^ value
	].

	^ super convertValue: value toType: targetType at: aNode
]

{ #category : #accessing }
LowtalkDynamicObjectType >> defaultSSAValueWith: builder [
	^ builder addDynamicLiteral: nil
]

{ #category : #accessing }
LowtalkDynamicObjectType >> defaultValue [
	^ nil
]

{ #category : #coercions }
LowtalkDynamicObjectType >> irConvertExplicitlyTo: targetType with: irBuilder at: node [
	targetType isBooleanType ifTrue: [ ^ self].
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
	targetType isSpecificDynamicObjectType ifTrue: [ ^ self ].
	
	targetType isPointerType ifTrue: [
		self halt
	].
	
	^ super irConvertExplicitlyTo: targetType with: irBuilder at: node
]

{ #category : #testing }
LowtalkDynamicObjectType >> isAnyDynamicObjectType [
	^ true
]

{ #category : #testing }
LowtalkDynamicObjectType >> isDynamicObjectType [
	^ true
]

{ #category : #accessing }
LowtalkDynamicObjectType >> name [
	^ #_DynamicObject
]

{ #category : #'as yet unclassified' }
LowtalkDynamicObjectType >> operationSignature [
	^ #object
]

{ #category : #printing }
LowtalkDynamicObjectType >> printOn: aStream [
	aStream nextPutAll: self name
]

{ #category : #accessing }
LowtalkDynamicObjectType >> size [
	^ compilationTarget pointerSize
]

{ #category : #'special messages' }
LowtalkDynamicObjectType >> specialMessageTypeForSelector: selector [
	DynamicObjectSpecialMessages at: selector ifPresent: [ :type | ^ type ].
	^ super specialMessageTypeForSelector: selector
]

{ #category : #coercions }
LowtalkDynamicObjectType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isSpecialGenericType ifTrue: [ ^ value ].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #converting }
LowtalkDynamicObjectType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isBooleanType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: false)].
	targetType isIntegerType ifTrue: [ ^ builder dynamicObjectToIntCast: value target: targetType ssaType ].
	targetType isFloatType ifTrue: [ ^ builder dynamicObjectToFloatCast: value target: targetType ssaType ].
	targetType isStructureType ifTrue: [ ^ builder dynamicObjectToStructureCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: targetType) ].
	targetType isSpecificDynamicObjectType ifTrue: [ ^ value ].
	
	targetType isPointerType ifTrue: [
		^ builder dynamicObjectToPointerCast: value target: targetType ssaType typeObject: (builder addDynamicLiteral: targetType)
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
