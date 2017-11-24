accessing
stringLiteral
	^ super stringLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle string token: token)
	]