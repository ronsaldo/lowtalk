initialization
initialize
	super initialize.
	compilationTarget ifNil: [ self error: 'Missing compilation target' ].
	readOnly := false.
	