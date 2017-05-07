visiting
visitReturnNode: node
	node value accept: self.
	node type: node value type.
	node type implicitlyConvertedTo: method returnType at: node.
	