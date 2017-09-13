accessing
comment
	^ super comment token ==> [ :c |
		self commands add: (LowtalkHighlightCommandApplyStyle commentStyle token: c)
	]