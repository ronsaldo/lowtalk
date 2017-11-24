accessing
colon
	^ super colon ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle keyword token: token)
	]