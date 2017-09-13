accessing
colon
	^ super colon ==> [ :token |
		self commands
			add: (LowtalkHighlightCommandApplyStyle keyword token: token)
	]