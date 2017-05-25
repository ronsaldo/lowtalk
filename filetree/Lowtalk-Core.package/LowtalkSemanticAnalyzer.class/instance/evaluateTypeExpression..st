as yet unclassified
evaluateTypeExpression: typeExpression
	^ (self asEvaluator evaluateValue: typeExpression) asLowtalkTypeIn: typeExpression.
