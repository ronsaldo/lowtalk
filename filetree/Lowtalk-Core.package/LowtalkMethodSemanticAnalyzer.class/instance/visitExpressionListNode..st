visiting
visitExpressionListNode: list
	| resultType |
	list pragmaList do: [ :pragma | self visitNode: pragma ].
	list locals do: [ :local | self visitNode: local ].
	
	resultType := compiler objectType.
	list expressions do: [ :node |
		self visitNode: node.
		resultType := node type.
	].

	list type: resultType.