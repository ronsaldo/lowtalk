accessing
fetchLineAndColumn
	| lineColumn |
	lineColumn := collection lineColumnAt: start.
	line := lineColumn first.
	column := lineColumn second.