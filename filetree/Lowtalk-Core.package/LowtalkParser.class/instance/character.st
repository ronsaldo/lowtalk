accessing
character
	^ super character ==> [ :token |
		LowtalkASTCharacterLiteral new
			position: token;
			value: token inputValue second;
			yourself
	]