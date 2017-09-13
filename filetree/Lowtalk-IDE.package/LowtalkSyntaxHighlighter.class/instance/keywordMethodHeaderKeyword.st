accessing
keywordMethodHeaderKeyword
	^ super keywordMethodHeaderKeyword ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle methodHeaderSelector token: tokens first);
			add: (LowtalkHighlightCommandApplyStyle localDefinition token: tokens second)
	]