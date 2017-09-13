accessing
number
	^ super number ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle number token: token)
	]