accessing
keyword: aKeyword
	^ (super keyword: aKeyword) ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle keyword token: token)
	]