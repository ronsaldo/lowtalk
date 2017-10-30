visiting
visitReturnNode: node
	self visitNode: node value.
	node type: node value type.
	node type implicitlyConvertedTo: method returnType at: node value.
	