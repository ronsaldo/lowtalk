accessing
literalPunctuation
	^ super literalPunctuation ==> [ :token |
			LowtalkASTSymbolLiteral new
				position: token;
				value: token inputValue asSymbol
	]