accessing
bar
	^ super bar ==> [ :token |
		self commands
			add: (LowtalkHighlightCommandApplyStyle bar token: token)
	]