Class {
	#name : #LowtalkBooleanLiteralType,
	#superclass : #LowtalkLiteralType,
	#category : #'Lowtalk-Core-Types'
}

{ #category : #converting }
LowtalkBooleanLiteralType >> asValueType [
	^ LowtalkBooleanType target: compilationTarget
]

{ #category : #coercions }
LowtalkBooleanLiteralType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isBooleanType ifTrue: [ ^ true ].

	^ false
]

{ #category : #coercions }
LowtalkBooleanLiteralType >> dispatchArithmeticCoerceWith: otherType [
	^ otherType arithmeticCoerceWithBooleanLiteral: self
]

{ #category : #testing }
LowtalkBooleanLiteralType >> isBooleanLiteralType [
	^ true
]

{ #category : #accessing }
LowtalkBooleanLiteralType >> name [
	^ #_BooleanLiteral
]

{ #category : #coercions }
LowtalkBooleanLiteralType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isBooleanType ifTrue: [
		^ builder constBool: value
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]
