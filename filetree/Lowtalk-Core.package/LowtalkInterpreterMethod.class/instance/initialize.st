initialization
initialize
	super initialize.
	arguments := #().
	temporaries := OrderedCollection new.
	hasLazySelector := false.
	bytecodeMethods := IdentityDictionary new.
	capturedVariable := Set new.
	outerClosureVariables := Set new.