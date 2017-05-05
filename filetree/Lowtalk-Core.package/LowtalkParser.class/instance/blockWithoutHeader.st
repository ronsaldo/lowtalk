accessing
blockWithoutHeader
	^ super blockWithoutHeader ==> [ :content |
		LowtalkASTBlockExpression new
			body: content;
			yourself
	]