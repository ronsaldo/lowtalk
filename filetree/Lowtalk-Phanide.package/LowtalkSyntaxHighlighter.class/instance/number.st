accessing
number
	^ super number ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle number token: token)
	]