Class {
	#name : #LowtalkPrimitiveType,
	#superclass : #LowtalkSingletonType,
	#category : #'Lowtalk-Core-Types'
}

{ #category : #testing }
LowtalkPrimitiveType >> canBeExplicitlyConvertedTo: targetType [
	(super canBeExplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ false
]

{ #category : #testing }
LowtalkPrimitiveType >> canBeImplicitlyConvertedTo: targetType [
	(super canBeImplicitlyConvertedTo: targetType) ifTrue: [ ^ true ].
	targetType isDynamicObjectType ifTrue: [ ^ true ].
	^ false
]

{ #category : #converting }
LowtalkPrimitiveType >> convertValue: value toSSAConstantWith: compiler [
	^ SLVMConstant type: self ssaType value: value
]

{ #category : #coercions }
LowtalkPrimitiveType >> irCoerceImplicitlyTo: targetType with: irBuilder at: node [
	targetType isDynamicObjectType ifTrue: [ ^ self ].
	^ super irCoerceImplicitlyTo: targetType with: irBuilder at: node
]

{ #category : #testing }
LowtalkPrimitiveType >> isPrimitiveType [
	^ true
]
