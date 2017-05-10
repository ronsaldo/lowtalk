as yet unclassified
evaluateTypeExpression: typeExpression
	| result |
	result := self asEvaluator evaluateValue: typeExpression.
	result isLowtalkType ifFalse: [ 
		typeExpression semanticError: 'Expected a type expression.'
	].

	^ result