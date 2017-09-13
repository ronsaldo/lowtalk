accessing
unaryMethodHeader
	^ super unaryMethodHeader ==> [ :token |
		self commands
			add: (LowtalkHighlightCommandApplyStyle methodHeaderSelector token: token)
	]