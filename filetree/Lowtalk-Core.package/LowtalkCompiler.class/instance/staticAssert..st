as yet unclassified
staticAssert: aBooleanExpression
	<compileTime>
	<lazy>
	aBooleanExpression value ifFalse: [
		aBooleanExpression node semanticError: 'Static assert failure.'
	].