accessing
symbolLiteral
	^ super symbolLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle symbol token: token)
	]