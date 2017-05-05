accessing
visitBlockNode: aBlockNode
	self solveBlockType: aBlockNode.
	^ aBlockNode type
	