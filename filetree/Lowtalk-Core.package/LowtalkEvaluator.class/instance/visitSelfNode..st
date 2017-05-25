visiting
visitSelfNode: aNode
	aNode setTypeIfNil: environment receiverType.
	^ environment receiver