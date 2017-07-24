visiting
visitReturnNode: node
	| value valueType returnContext nonLocalReturnMethod |
	value := self visitNode: node value.
	valueType := node value type.
	
	method hasLocalReturns ifFalse: [
		returnContext := self getCurrentReturnContext.
		nonLocalReturnMethod := self getCurrentNonLocalReturnMethod.
		nonLocalReturnMethod ~~ method ifTrue: [
			nonLocalReturnMethod returnType isVoidType ifTrue: [ 
				^ builder returnVoidFromContext: returnContext
			] ifFalse: [ 
				value := self coerceImplicitly: value type: valueType to: nonLocalReturnMethod returnType at: node.
				^ builder return: value fromContext: returnContext
			]
		]
	].

	method returnType isVoidType ifTrue: [
		^ builder returnVoid
	] ifFalse: [
		value := self coerceImplicitly: value type: valueType to: method returnType at: node.
		^ builder return: value 
	]
