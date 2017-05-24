accessing
blockSelfType
	^ super blockSelfType ==> [ :list |
		list third
	]