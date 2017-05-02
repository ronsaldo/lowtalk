accessing
expressionList
	^ super expressionList ==> [ :list |
		LowtalkASTExpressionList new
			position: (list third ifNil: [list fourth ifNotEmpty: [:dottedList | dottedList first]]);
			pragmaList: list first;
			locals: list second;
			expressions: (({ list third } , (list fourth collect: #second)) select: #isNotNil);
			yourself
	]