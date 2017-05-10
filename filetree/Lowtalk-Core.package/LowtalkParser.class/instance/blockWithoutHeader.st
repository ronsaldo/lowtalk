accessing
blockWithoutHeader
	^ super blockWithoutHeader ==> [ :content |
		LowtalkASTBlockExpression new
			arguments: #();
			body: content;
			yourself
	]