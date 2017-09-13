tokens
operator: aKeyword
	^ (super operator: aKeyword) ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle operator token: token)
	]