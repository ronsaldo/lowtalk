accessing
unaryMethodHeader
	^ super unaryMethodHeader ==> [ :token |
		self commands
			add: (PhanideHighlightCommandStyle methodHeaderSelector token: token)
	]