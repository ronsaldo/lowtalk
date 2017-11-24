accessing
cstringLiteral
	^ super cstringLiteral ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle string token: token)
	]