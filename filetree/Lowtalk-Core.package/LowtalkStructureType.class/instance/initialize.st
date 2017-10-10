initialization
initialize
	super initialize.
	fields := #().
	fieldNames := #().
	pendingMethods := OrderedDictionary new.
	methods := OrderedDictionary new.
	