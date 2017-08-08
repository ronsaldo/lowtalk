visiting
visitExpressionListNode: list
	| hasToPop |
	hasToPop := false.
	list expressions do: [ :node |
		hasToPop ifTrue: [ irBuilder popTop ].
		
		self visitNode: node.
		hasToPop := true.
	]