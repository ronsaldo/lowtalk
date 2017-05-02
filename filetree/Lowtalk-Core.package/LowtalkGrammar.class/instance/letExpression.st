expressions
letExpression
	^ letKeyword , identifier , (lessThan , typeExpression , greaterThan) optional, (assignOperator , expression) optional