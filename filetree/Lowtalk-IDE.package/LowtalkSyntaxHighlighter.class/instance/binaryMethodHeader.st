accessing
binaryMethodHeader
	^ super binaryMethodHeader ==> [ :tokens |
		self commands
			add: (LowtalkHighlightCommandApplyStyle methodHeaderSelector token: tokens first);
			add: (LowtalkHighlightCommandApplyStyle localDefinition token: tokens third)
	]