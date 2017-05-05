accessing
letExpression
	^ super letExpression ==> [ :list |
		LowtalkASTLetExpression  new
			position: list first;
			identifier: list first inputValue asSymbol;
			typeExpression: list third;
			initialValue: list fourth;
			yourself
	]