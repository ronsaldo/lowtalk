accessing
bar
	^ super bar ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle bar token: token)
	]