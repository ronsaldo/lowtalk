as yet unclassified
evaluateSelfInstanceTypeInEnvironment: environment at: node
	node semanticError: 'Cannot evaluate _SelfInstanceType for a _SelfType of {1}.' format: { self name }