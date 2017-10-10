initialization
initialize
	super initialize.
	fields := #().
	fieldNames := #().
	superclassEvaluated := false.
	pendingMethods := OrderedDictionary new.
	category := 'Uncategorized'.
	organization := IdentityDictionary new.
	