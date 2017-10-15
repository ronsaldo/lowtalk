initialization
initialize
	super initialize.
	fields := #().
	fieldNames := #().
	pendingMethods := OrderedDictionary new.
	methodDict := OrderedDictionary new.
	