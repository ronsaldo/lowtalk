accessing
trueExpression
	^ super trueExpression ==> [ :token |
		LowtalkASTBooleanLiteral new position: token; value: true
	]