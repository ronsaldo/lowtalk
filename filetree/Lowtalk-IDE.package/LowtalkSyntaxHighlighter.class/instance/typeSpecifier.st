accessing
typeSpecifier
	^ super typeSpecifier ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle typeExpression firstToken: tokens first lastToken: tokens last)
	]