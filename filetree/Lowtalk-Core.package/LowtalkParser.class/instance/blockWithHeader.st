accessing
blockWithHeader
	^ super blockWithHeader ==> [ :list |
		LowtalkASTBlockExpression new
			returnTypeExpression: list first;
			arguments: list second;
			body: (list third ifNotNil: #second);
			yourself
	]