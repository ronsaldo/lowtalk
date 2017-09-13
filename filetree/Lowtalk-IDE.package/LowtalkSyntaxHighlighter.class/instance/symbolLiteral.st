accessing
symbolLiteral
	^ super symbolLiteral ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle symbol token: token)
	]