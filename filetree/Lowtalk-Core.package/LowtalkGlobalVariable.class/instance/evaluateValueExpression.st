accessing
evaluateValueExpression
	super evaluateValueExpression.
	(self rawValue isNotNil and: [ self valueType isDynamicObjectType ]) ifTrue: [
		compiler registerVariable: self objectInstanceValue: self rawValue.
	].