accessing
binaryMethodHeader
	^ super binaryMethodHeader ==> [ :list |
		LowtalkASTMethodExpression new
			selector: list first inputValue asSymbol;
			arguments: {LowtalkASTMethodArgument new
				position: list third;
				name: list third inputValue;
				typeExpression: list second};
			yourself
	]