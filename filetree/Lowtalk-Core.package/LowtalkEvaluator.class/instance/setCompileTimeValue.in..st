visiting
setCompileTimeValue: value in: node
	node compileTimeValue: value.
	node type: value type.
	^ node compileTimeValue