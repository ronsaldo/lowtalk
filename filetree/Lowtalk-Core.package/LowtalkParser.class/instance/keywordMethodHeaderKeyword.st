accessing
keywordMethodHeaderKeyword
	^ super keywordMethodHeaderKeyword ==> [ :list |
		{ list first .
		LowtalkASTMethodArgument new
			position: list third;
			name: list third inputValue;
			typeExpression: list second
		}
	]