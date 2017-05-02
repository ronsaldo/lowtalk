accessing
returnExpression
	^ super returnExpression ==> [:list |
		LowtalkASTReturnStatement new
			position: list first;
			value: list second;
			yourself
	]