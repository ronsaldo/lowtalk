accessing
blockArgument
	^ super blockArgument ==> [ :list |
		LowtalkASTBlockArgument new
			position: list first;
			name: list second inputValue asSymbol;
			typeExpression: list third;
			yourself
	]