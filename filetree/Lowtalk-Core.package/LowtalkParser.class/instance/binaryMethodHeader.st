accessing
binaryMethodHeader
	^ super binaryMethodHeader ==> [ :list |
		LowtalkASTMethodExpression new
			selector: list first inputValue asSymbol;
			arguments: (LowtalkASTMethodArgument new
				position: list second;
				name: list second inputValue;
				typeExpression: list third);
			yourself
	]