visiting
visitSuperNode: aNode
	aNode setTypeIfNil: environment receiverType.
	^ environment receiver