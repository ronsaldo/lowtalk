accessing
superExpression
	^ super superExpression ==> [ :token | LowtalkASTSuperReference new position: token ]