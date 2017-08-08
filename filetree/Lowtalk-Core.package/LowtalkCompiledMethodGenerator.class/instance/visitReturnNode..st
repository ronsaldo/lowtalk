visiting
visitReturnNode: node
	| valueType returnType |
	self visitNode: node value.
	valueType := node value type.
	
	method hasLocalReturns ifFalse: [
		self halt
	] ifTrue: [
		returnType := method returnType.
	].

	self coerceImplicitlyFrom: valueType to: returnType at: node.
	irBuilder returnTop
	