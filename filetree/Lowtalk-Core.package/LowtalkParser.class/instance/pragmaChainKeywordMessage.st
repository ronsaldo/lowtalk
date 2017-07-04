accessing
pragmaChainKeywordMessage
	^ super pragmaChainKeywordMessage ==> [ :list |
		| selector |
		selector := ''.
		list do: [ :each | selector := selector , each first inputValue ].
		LowtalkASTMessage new
			position: list first first;
			selector: selector asSymbol;
			arguments: (list collect: #second);
			yourself
	]