accessing
localDeclaration
	^ super localDeclaration ==> [ :list |
		LowtalkASTLocalVariable new
			position: list first;
			name: list first inputValue asSymbol;
			typeExpression: list second;
			yourself
	]