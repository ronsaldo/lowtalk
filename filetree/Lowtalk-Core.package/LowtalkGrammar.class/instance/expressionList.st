expressions
expressionList
	^ pragmaList, localDeclarations optional, optionalExpression , (dot , optionalExpression) star