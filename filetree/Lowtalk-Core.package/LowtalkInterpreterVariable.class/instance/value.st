accessing
value
	<compileTime>
	valueExpression ifNotNil: [ self evaluateValueExpression ].
	^ self rawValue