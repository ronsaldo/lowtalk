accessing
identifier
	^ super identifier ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle identifier token: token)
	]