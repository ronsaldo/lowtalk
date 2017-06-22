visiting
visitExpressionListNode: list
	| result |
	result := nil.
	list expressions do: [ :node |
		result := self visitNode: node.
	].
	^ result