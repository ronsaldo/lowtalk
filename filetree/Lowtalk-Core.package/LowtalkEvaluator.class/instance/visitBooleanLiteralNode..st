visiting
visitBooleanLiteralNode: aNode
	aNode setTypeIfNil: compiler booleanType.
	^ aNode value