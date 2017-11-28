initialization
initialize
	super initialize.
	allSlots := #().
	fields := #().
	fieldNames := #().
	pendingMethods := OrderedDictionary new.
	methodSignatureDictionary := Dictionary new.
	methodDict := OrderedDictionary new.
	organization := IdentityDictionary new.
	minimalAlignment := 1.
	