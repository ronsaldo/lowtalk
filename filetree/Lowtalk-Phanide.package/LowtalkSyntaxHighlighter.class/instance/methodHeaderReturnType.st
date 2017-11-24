accessing
methodHeaderReturnType
	^ super methodHeaderReturnType ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle typeExpression firstToken: tokens first lastToken: tokens last)
	]