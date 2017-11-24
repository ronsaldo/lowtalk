tokens
operator: aKeyword
	^ (super operator: aKeyword) ==> [ :token |
		self commands add: (PhanideHighlightCommandStyle operator token: token)
	]