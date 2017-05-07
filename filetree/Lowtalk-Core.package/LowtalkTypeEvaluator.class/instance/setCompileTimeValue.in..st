initialization
setCompileTimeValue: value in: node
	node compileTimeValue: (value asLowtalkTypeIn: node).
	node type: node compileTimeValue.
	^ node compileTimeValue