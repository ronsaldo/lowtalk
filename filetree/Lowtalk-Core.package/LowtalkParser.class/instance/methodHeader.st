accessing
methodHeader
	^ super methodHeader ==> [ :list |
		list second
			returnTypeExpression: list first; yourself
	]