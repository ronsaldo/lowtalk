visiting
visitMessageNode: aNode
	aNode compileTimeValue ifNotNil: [ ^ aNode compileTimeValue ssaValue ].
	self halt.