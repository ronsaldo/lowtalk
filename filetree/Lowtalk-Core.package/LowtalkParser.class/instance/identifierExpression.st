accessing
identifierExpression
	^ super identifierExpression ==> [ :value |
		LowtalkASTIdentifierReference new
			position: value;
			value: value inputValue asSymbol;
			yourself
	]