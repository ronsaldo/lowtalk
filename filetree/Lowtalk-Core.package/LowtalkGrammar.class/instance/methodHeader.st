expressions
methodHeader
	^ optionalTypeExpression, (unaryMethodHeader / binaryMethodHeader / keywordMethodHeader)