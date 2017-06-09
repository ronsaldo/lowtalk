accessing
evaluateValueExpression
	super evaluateValueExpression.
	(value isNotNil and: [ self valueType isDynamicObjectType ]) ifTrue: [
		compiler registerVariable: self objectInstanceValue: value.
	].