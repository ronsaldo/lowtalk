accessing
thisContextExpression
	^ super thisContextExpression ==> [ :token |
		LowtalkASTThisContextReference new position: token
	]