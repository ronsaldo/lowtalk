accessing
caret
	^ super caret ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle keyword token: token)
	]