visiting
visitExpressionListNode: expressionList
	| result |
	result := nil.
	expressionList expressions do: [ :expr |
		result := self evaluate: expr
	].
	^ result
