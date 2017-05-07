visiting
visitExpressionListNode: list
	| result |
	result := nil.
	list expressions do: [ :node |
		result := node accept: self.
	].
	^ result