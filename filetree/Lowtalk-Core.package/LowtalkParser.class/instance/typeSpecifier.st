accessing
typeSpecifier
	^ super typeSpecifier ==> [ :list |
		list second
	]