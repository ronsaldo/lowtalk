accessing
optionalTypeExpression
	^ super optionalTypeExpression ==> [ :list |
		list ifNotNil: [ list second ]
	]