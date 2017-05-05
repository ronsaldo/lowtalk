accessing
blockExpression
	^ super blockExpression ==> [ :list |
		list second position: list first; yourself
	]