as yet unclassified
evaluateSelfClassTypeInEnvironment: environment at: node
	node semanticError: 'Cannot evaluate _SelfClassType for a _SelfType of {1}.' format: { self name }