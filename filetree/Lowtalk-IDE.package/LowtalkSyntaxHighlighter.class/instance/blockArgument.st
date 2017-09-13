accessing
blockArgument
	^ super blockArgument ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle localDefinition firstToken: tokens first lastToken: tokens second)
	]