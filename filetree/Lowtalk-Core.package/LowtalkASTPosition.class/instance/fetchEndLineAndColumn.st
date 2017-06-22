accessing
fetchEndLineAndColumn
	| lineColumn |
	lineColumn := collection lineColumnAt: stop.
	endLine := lineColumn first.
	endColumn := lineColumn second.