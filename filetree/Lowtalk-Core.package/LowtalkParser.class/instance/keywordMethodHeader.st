accessing
keywordMethodHeader
	^ super keywordMethodHeader ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :el | selector := selector , el first inputValue ].
		
		LowtalkASTMethodExpression new
			position: list first first;
			selector: selector asSymbol;
			arguments: (list collect: #second);
			yourself
	]