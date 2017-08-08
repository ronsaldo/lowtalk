visiting
visitLetExpressionNode: node
	node initialValue ifNil: [ ^ irBuilder pushLiteral: node type defaultValue ].
	
	self visitNode: node initialValue.
	self coerceImplicitlyFrom: node initialValue type to: node valueType at: node.
	node binding irStoreStackTopWith: irBuilder.
