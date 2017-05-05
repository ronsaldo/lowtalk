accessing
keywordMethodHeader
	^ super keywordMethodHeader ==> [ :list |
		self halt
	]