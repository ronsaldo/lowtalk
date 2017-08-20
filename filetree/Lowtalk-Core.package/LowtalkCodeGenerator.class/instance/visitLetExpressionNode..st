visiting
visitLetExpressionNode: node
	| initialValue |
	node initialValue ifNotNil: [
		initialValue := self visitNode: node initialValue.
		initialValue := self coerceImplicitly: initialValue type: node initialValue type to: node valueType at: node.
		self store: initialValue in: node binding ssaValue
	].

	^ node binding ssaValue