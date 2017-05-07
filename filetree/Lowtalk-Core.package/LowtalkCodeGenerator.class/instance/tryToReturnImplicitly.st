as yet unclassified
tryToReturnImplicitly
	| returnType |
	returnType := method returnType.
	returnType isVoidType ifTrue: [ ^ builder returnVoid ].
	
	(receiverType canBeImplicitlyConvertedTo: returnType) ifTrue: [ self returnSelf ].

	method node semanticError: 'Not all of the method code paths are returning something valid.'