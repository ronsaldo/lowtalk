accessing
blockArgument
	^ super blockArgument ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle localDefinition firstToken: tokens first lastToken: tokens second)
	]