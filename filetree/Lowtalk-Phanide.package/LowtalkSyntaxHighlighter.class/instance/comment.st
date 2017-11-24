accessing
comment
	^ super comment token ==> [ :c |
		self commands add: (PhanideHighlightCommandStyle commentStyle token: c)
	]