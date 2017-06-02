accessing
expressionList
	^ super expressionList ==> [ :list |
		LowtalkASTExpressionList new
			position: (list third ifNil: [list fourth ifEmpty: [ LowtalkASTPosition empty ] ifNotEmpty: [:dottedList | dottedList first first ]]);
			pragmaList: list first;
			locals: list second;
			expressions: (({ list third } , (list fourth collect: #second)) select: #isNotNil);
			yourself
	]