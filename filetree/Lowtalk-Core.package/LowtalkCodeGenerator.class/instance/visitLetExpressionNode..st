visiting
visitLetExpressionNode: node
	| initialValue |
	node initialValue ifNotNil: [
		initialValue := node initialValue accept: self.
		initialValue := self coerceImplicitly: initialValue type: node initialValue type to: node valueType at: node.
		builder store: initialValue in: node binding ssaValue
	].

	^ node binding ssaValue