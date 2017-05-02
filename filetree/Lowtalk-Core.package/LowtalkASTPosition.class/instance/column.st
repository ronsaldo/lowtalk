accessing
column
	column ifNil: [ self fetchLineAndColumn ].
	^ column