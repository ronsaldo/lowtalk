accessing
letExpression
	^ super letExpression ==> [ :tokens |
		self commands add: (LowtalkHighlightCommandApplyStyle localDefinition token: tokens second)
	]