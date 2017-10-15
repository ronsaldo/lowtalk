initialization
initialize
	super initialize.
	compileTimeOnly := false.
	pendingMethods := Dictionary new.
	methodDict := Dictionary new.