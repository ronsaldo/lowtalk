accessing
symbolKeywordLiteral
	^ super symbolKeywordLiteral ==> [ :token |
		LowtalkASTSymbolLiteral new
			position: token;
			value: token inputValue allButFirst asSymbol;
			yourself
	]