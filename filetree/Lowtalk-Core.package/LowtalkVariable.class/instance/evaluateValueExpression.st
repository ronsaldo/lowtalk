accessing
evaluateValueExpression
	valueExpression ifNil: [ ^ self ].
	self value: valueExpression value.
	