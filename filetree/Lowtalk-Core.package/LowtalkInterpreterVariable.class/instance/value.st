accessing
value
	<compileTime>
	valueExpression ifNotNil: [ self evaluateValueExpression ].
	^ value