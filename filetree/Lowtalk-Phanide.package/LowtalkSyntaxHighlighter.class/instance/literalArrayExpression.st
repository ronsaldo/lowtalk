accessing
literalArrayExpression
	^ super literalArrayExpression ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens first);
			add: (PhanideHighlightCommandStyle literalArrayParent token: tokens last)
	]