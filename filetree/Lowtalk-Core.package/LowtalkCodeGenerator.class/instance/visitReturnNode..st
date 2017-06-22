visiting
visitReturnNode: node
	| value valueType |
	value := self visitNode: node value.
	valueType := node value type.
	
	method returnType isVoidType ifTrue: [
		^ builder returnVoid
	] ifFalse: [
		^ builder return: (self coerceImplicitly: value type: valueType to: method returnType at: node)
	]