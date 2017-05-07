accessing
value
	valueExpression ifNotNil: [ self evaluateValueExpression ].
	^ value