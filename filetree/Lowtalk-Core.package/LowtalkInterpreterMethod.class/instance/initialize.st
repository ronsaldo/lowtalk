initialization
initialize
	super initialize.
	arguments := #().
	temporaries := OrderedCollection new.
	hasLazySelector := false.
	bytecodeMethods := IdentityDictionary new.
	capturedVariable := SLVMOrderedInsertionSet new.
	outerClosureVariables := SLVMOrderedInsertionSet new.