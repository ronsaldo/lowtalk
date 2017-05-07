accessing
unaryExpression
	^ super unaryExpression ==> [ :list |
		| result |
		result := list first.
		list second do: [ :message |
			message receiver: result.
			result := message
		].
		result
	]