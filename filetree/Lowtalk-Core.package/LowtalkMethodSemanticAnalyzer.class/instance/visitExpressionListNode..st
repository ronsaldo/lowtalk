visiting
visitExpressionListNode: list
	| resultType |
	list pragmaList do: [ :pragma | pragma accept: self ].
	list locals do: [ :local | local accept: self ].
	
	resultType := compiler objectType.
	list expressions do: [ :node |
		node accept: self.
		resultType := node type.
	].

	list type: resultType.