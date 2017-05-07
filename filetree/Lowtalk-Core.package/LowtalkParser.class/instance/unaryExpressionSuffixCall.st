accessing
unaryExpressionSuffixCall
	^ super unaryExpressionSuffixCall ==> [ :list |
		LowtalkASTCallExpression new
			position: list first;
			arguments: list second;
			yourself 
	]