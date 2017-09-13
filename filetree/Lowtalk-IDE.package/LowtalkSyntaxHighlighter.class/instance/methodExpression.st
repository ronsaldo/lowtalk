accessing
methodExpression
	^ super methodExpression ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle methodBracket token: tokens first);
			add: (LowtalkHighlightCommandApplyStyle methodBracket token: tokens last)
	]