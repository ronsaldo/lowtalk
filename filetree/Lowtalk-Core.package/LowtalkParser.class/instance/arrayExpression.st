accessing
arrayExpression
	^ super arrayExpression ==> [ :list |
		LowtalkASTArrayExpression new
			position: list first;
			expressionList: list second;
			yourself
	]