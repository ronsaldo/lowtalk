accessing
methodHeaderReturnType
	^ super methodHeaderReturnType ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle typeExpression firstToken: tokens first lastToken: tokens last)
	]