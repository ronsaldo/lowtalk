accessing
falseExpression
	^ super falseExpression ==> [ :token |
		LowtalkASTBooleanLiteral new position: token; value: false
	]