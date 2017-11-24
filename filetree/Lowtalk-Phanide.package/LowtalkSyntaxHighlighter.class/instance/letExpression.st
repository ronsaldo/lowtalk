accessing
letExpression
	^ super letExpression ==> [ :tokens |
		self commands add: (PhanideHighlightCommandStyle localDefinition token: tokens second)
	]