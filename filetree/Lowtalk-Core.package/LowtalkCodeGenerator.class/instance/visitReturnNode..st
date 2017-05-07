visiting
visitReturnNode: node
	| value valueType |
	value := node value accept: self.
	valueType := node value type.
	
	(valueType isVoidType and: [ method returnType isVoidType ]) ifTrue: [
		^ builder returnVoid
	] ifFalse: [
		^ builder return: (self coerceImplicitly: value type: valueType to: method returnType at: node)
	]