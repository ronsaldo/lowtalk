accessing
keywordMethodHeaderKeyword
	^ super keywordMethodHeaderKeyword ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle methodHeaderSelector token: tokens first);
			add: (PhanideHighlightCommandStyle localDefinition token: tokens third)
	]