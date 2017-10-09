accessing
methodExpression
	^ super methodExpression ==> [ :list |
		list second
			position: (list first asLowtalkASTPosition until: list last);
			body: list third;
			yourself
	]