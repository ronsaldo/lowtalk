tokens
typeBinaryOperator
	^ super typeBinaryOperator ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle operator token: token)
	]