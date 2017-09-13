accessing
cstringLiteral
	^ super cstringLiteral ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle string token: token)
	]