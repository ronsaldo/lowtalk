visiting
visitArrayNode: aNode
	aNode expressionList do: [ :el |
		self visitNode: el.
		(el type canBeImplicitlyConvertedTo: self compiler objectType) ifFalse: [ 
			el semanticError: 'Cannot coerce implicitly object of type {1} to object.' format: { el type name }
		]
	].
	aNode type: self compiler objectType.