Class {
	#name : #LowtalkLiteralType,
	#superclass : #LowtalkSingletonType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #converting }
LowtalkLiteralType >> asDefaultReturnTypeWith: aCompiler [
	^ aCompiler objectType
]

{ #category : #testing }
LowtalkLiteralType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ false
]

{ #category : #converting }
LowtalkLiteralType >> convertValue: value toType: targetType at: sendingNode [
	self = targetType ifTrue: [ ^ value ].
	^ targetType convertLiteralValue: value fromType: self at: sendingNode
]

{ #category : #coercions }
LowtalkLiteralType >> irCoerceImplicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: builder at: node
]

{ #category : #testing }
LowtalkLiteralType >> isLiteralType [
	^ true
]

{ #category : #coercions }
LowtalkLiteralType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [
		^ builder addDynamicLiteral: value
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]

{ #category : #coercions }
LowtalkLiteralType >> ssaConvert: value explicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [ 
		^ builder addDynamicLiteral: value
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node
]
