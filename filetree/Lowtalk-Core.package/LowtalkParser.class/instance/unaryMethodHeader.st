accessing
unaryMethodHeader
	^ super unaryMethodHeader ==> [ :selector |
		LowtalkASTMethodExpression new
			position: selector;
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]