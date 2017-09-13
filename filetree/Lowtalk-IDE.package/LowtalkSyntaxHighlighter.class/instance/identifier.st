accessing
identifier
	^ super identifier ==> [ :token |
		self commands add: (LowtalkHighlightCommandApplyStyle identifier token: token)
	]