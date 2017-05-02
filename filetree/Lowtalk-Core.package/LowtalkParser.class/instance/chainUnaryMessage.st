accessing
chainUnaryMessage
	^ super chainUnaryMessage ==> [ :selector |
		LowtalkASTMessage new
			position: selector;
			selector: selector inputValue asSymbol;
			arguments: #();
			yourself
	]