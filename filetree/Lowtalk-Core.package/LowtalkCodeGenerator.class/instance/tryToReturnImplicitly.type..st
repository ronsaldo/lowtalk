as yet unclassified
tryToReturnImplicitly: value type: valueType
	| returnType |
	returnType := method returnType.
	returnType isVoidType ifTrue: [ ^ builder returnVoid ].
	
	(valueType canBeImplicitlyConvertedTo: returnType) ifTrue: [
		^ builder return: (self coerceImplicitly: value type: valueType to: method returnType at: method node)
	].

	method node semanticError: 'Not all of the method code paths are returning something valid.'