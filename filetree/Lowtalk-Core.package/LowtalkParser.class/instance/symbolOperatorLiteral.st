accessing
symbolOperatorLiteral
	^ super symbolOperatorLiteral ==> [ :token |
		LowtalkASTSymbolLiteral new
			position: token;
			value: token inputValue allButFirst asSymbol;
			yourself
	]