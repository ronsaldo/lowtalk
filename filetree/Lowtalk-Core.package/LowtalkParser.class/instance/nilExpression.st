accessing
nilExpression
	^ super nilExpression ==> [ :token |
		LowtalkASTNilLiteral new position: token
	]