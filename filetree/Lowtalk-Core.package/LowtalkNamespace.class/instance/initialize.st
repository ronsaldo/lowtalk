initialization
initialize
	super initialize.
	compileTimeOnly := false.
	pendingMethods := Dictionary new.
	methods := Dictionary new.