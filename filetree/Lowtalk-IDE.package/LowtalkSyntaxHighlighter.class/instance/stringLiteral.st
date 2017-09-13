accessing
stringLiteral
	^ super stringLiteral ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle string token: token)
	]