accessing
methodHeader
	^ super methodHeader ==> [ :list |
		list first
			returnTypeExpression: list second; yourself
	]