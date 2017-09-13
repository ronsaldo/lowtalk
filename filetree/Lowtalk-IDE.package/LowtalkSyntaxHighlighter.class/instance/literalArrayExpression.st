accessing
literalArrayExpression
	^ super literalArrayExpression ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle literalArrayParent token: tokens first);
			add: (LowtalkHighlightCommandApplyStyle literalArrayParent token: tokens last)
	]