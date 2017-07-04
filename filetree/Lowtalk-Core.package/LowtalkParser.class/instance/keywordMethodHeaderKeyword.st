accessing
keywordMethodHeaderKeyword
	^ super keywordMethodHeaderKeyword ==> [ :list |
		{ list first .
		LowtalkASTMethodArgument new
			position: list second;
			name: list second inputValue;
			typeExpression: list third
		}
	]