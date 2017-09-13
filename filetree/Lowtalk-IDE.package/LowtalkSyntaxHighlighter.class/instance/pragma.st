accessing
pragma
	^ super pragma ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle pragma firstToken: tokens first lastToken: tokens last)
	]