visiting
visitExpressionListNode: list
	| result |
	result := nil.
	list expressions do: [ :node |
		builder isLastTerminator ifFalse: [ 
			result := self visitNode: node.
		]
	].

	(result isNil and: [list type isDynamicObjectType]) ifTrue: [ 
		result := builder addDynamicLiteral: nil
	].

	^ result