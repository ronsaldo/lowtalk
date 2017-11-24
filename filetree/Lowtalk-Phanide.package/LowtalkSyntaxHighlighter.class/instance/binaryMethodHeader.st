accessing
binaryMethodHeader
	^ super binaryMethodHeader ==> [ :tokens |
		self commands
			add: (PhanideHighlightCommandStyle methodHeaderSelector token: tokens first);
			add: (PhanideHighlightCommandStyle localDefinition token: tokens third)
	]