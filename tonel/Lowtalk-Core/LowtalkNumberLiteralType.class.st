Class {
	#name : #LowtalkNumberLiteralType,
	#superclass : #LowtalkLiteralType,
	#category : 'Lowtalk-Core-Types'
}

{ #category : #coercions }
LowtalkNumberLiteralType >> irCoerceImplicitlyTo: targetType with: irBuilder at: node [
	targetType isIntegerType ifTrue: [ ^ irBuilder send: #asInteger ].
	targetType isFloatType ifTrue: [ ^ irBuilder send: #asFloat ].
	^ super irCoerceImplicitlyTo: targetType with: irBuilder at: node
]
