accessing
methodExpression
	^ super methodExpression ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle methodBracket token: tokens first);
			add: (PhanideHighlightCommandStyle methodBracket token: tokens last)
	]