accessing
endColumn
	endColumn ifNil: [ self fetchEndLineAndColumn ].
	^ endColumn