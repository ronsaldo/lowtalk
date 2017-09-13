accessing
literalArrayParent
	^ super literalArrayParent ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle literalArrayParent token: tokens first);
			add: (LowtalkHighlightCommandApplyStyle literalArrayParent token: tokens last)
	]