accessing
keyword: aKeyword
	^ (super keyword: aKeyword) ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle keyword token: token)
	]