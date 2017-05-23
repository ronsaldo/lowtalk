accessing
literalArrayParent
	^ super literalArrayParent ==> [ :list |
		LowtalkASTArrayLiteral new
			position: list first;
			value: (list second collect: #asLiteralValue)
		]