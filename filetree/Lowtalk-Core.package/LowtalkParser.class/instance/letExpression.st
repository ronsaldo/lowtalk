accessing
letExpression
	^ super letExpression ==> [ :list |
		LowtalkASTLetExpression  new
			position: list first;
			identifier: list first inputValue asSymbol;
			typeExpression: (list third ifNotNil: [:typeList | typeList second]);
			initialValue: list fourth;
			yourself
	]