accessing
blockExpression
	^ super blockExpression ==> [ :list |
		list second position: (list first asLowtalkASTPosition until: list last); yourself
	]