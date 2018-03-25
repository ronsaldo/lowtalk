Class {
	#name : #LowtalkCompileTimeType,
	#superclass : #LowtalkSingletonType,
	#instVars : [
		'name'
	],
	#category : 'Lowtalk-Core-Types'
}

{ #category : #testing }
LowtalkCompileTimeType >> canBeImplicitlyConvertedTo: targetType [
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ super canBeImplicitlyConvertedTo: targetType
]

{ #category : #coercions }
LowtalkCompileTimeType >> irCoerceImplicitlyTo: targetType with: irBuilder at: node [
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: irBuilder at: node
]

{ #category : #testing }
LowtalkCompileTimeType >> isCompileTimeType [
	^ true
]

{ #category : #accessing }
LowtalkCompileTimeType >> name [
	^ name
]

{ #category : #accessing }
LowtalkCompileTimeType >> name: anObject [
	name := anObject
]

{ #category : #coercions }
LowtalkCompileTimeType >> ssaCoerce: value implicitlyTo: targetType with: builder at: node [
	targetType isDynamicObjectType ifTrue: [
		value isNamespace ifTrue: [
			^ value dynamicObjectWithBuilder: builder
		].
		^ builder addDynamicLiteral: value
	].
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node
]
