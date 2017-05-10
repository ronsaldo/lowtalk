visiting
visitExpressionListNode: expressionList
	| result resultType |
	result := nil.
	resultType := self compiler objectType.
	expressionList expressions do: [ :expr |
		result := self evaluate: expr.
		resultType := expr type.
	].
	expressionList type: resultType.
	^ result
