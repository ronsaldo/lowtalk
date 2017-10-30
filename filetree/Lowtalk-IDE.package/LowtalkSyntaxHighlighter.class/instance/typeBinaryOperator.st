tokens
typeBinaryOperator
	^ super typeBinaryOperator ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle operator token: token)
	]