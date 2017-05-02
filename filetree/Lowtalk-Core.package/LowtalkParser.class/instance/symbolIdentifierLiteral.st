accessing
symbolIdentifierLiteral
	^ super symbolIdentifierLiteral ==> [ :token |
		LowtalkASTSymbolLiteral new
			position: token;
			value: token inputValue allButFirst asSymbol;
			yourself
	]