accessing
caret
	^ super caret ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle keyword token: token)
	]