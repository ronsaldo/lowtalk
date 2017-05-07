accessing
callExpressionArguments
	^ super callExpressionArguments ==> [ :list |
		list ifNil: [ #() ] ifNotNil: [ 
			{list first} , (list second collect: #second)
		]
	]