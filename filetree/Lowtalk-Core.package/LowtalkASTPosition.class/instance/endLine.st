accessing
endLine
	endLine ifNil: [ self fetchEndLineAndColumn ].
	^ endLine