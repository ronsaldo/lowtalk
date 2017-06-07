as yet unclassified
tryToReturnImplicitly: value type: valueType
	| returnType |
	returnType := method returnType.
	returnType isVoidType ifTrue: [ ^ builder returnVoid ].
	
	(valueType canBeImplicitlyConvertedTo: returnType) ifFalse: [
		method node semanticError: 'Cannot convert implicitly value of type {1} into type {2} for returning.' format: { valueType name . returnType name }
	].

	^ builder return: (self coerceImplicitly: value type: valueType to: method returnType at: method node)

	