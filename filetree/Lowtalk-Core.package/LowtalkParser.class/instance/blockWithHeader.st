accessing
blockWithHeader
	^ super blockWithHeader ==> [ :list |
		LowtalkASTBlockExpression new
			returnTypeExpression: list first;
			selfTypeExpression: list second;
			arguments: list third;
			body: list last;
			yourself
	]