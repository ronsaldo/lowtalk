accessing
arrayExpressionList
	^ super arrayExpressionList ==> [ :list |
		({list first } , (list second collect: #second)) select: #isNotNil
	]