accessing
unaryExpressionSuffixMessage
	^ super unaryExpressionSuffixMessage ==> [ :selector |
		LowtalkASTMessage new
			position: selector;
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]