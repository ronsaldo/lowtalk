accessing
pragma
	^ super pragma ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle pragma firstToken: tokens first lastToken: tokens last)
	]