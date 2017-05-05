accessing
unaryMethodHeader
	^ super unaryMethodHeader ==> [ :list |
		self halt
	]