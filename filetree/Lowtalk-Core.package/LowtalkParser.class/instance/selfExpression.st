accessing
selfExpression
	^ super selfExpression ==> [ :token | LowtalkASTSelfReference new position: token ]