accessing
literalArrayExpression
	^ super literalArrayExpression ==> [ :list |
		LowtalkASTArrayLiteral new
			position: list first;
			value: (list second collect: #asLiteralValue)
		]