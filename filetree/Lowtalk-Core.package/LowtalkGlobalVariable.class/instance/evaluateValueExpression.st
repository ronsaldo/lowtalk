accessing
evaluateValueExpression
	super evaluateValueExpression.
	(self rawValue isNotNil and: [ self valueType isAnyDynamicObjectType ]) ifTrue: [
		compiler registerVariable: self objectInstanceValue: self rawValue.
	].