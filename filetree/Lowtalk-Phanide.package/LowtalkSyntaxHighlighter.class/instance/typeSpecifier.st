accessing
typeSpecifier
	^ super typeSpecifier ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle typeExpression firstToken: tokens first lastToken: tokens last)
	]