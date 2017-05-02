accessing
line
	line ifNil: [ self fetchLineAndColumn ].
	^ line