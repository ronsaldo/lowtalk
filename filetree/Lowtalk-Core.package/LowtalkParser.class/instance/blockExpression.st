accessing
blockExpression
	^ super blockExpression ==> [ :list |
		LowtalkASTBlockExpression new
			position: list first;
			body: list second;
			yourself
	]