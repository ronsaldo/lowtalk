accessing
letExpression
	^ super letExpression ==> [ :list |
		LowtalkASTLetExpression  new
			position: list first;
			identifier: list second inputValue asSymbol;
			typeExpression: list third;
			initialValue: (list fourth ifNotNil: [:initial | initial second]);
			yourself
	]