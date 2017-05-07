coercions
implicitlyConvertedTo: targetType at: node
	(self canBeImplicitlyConvertedTo: targetType) ifFalse: [
		node semanticError: 'Cannot implicitly convert value of type "{1}" to type "{2}"' format: { self name . targetType name }
	]