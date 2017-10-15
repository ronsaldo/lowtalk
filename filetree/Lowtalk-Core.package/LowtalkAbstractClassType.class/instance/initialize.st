initialization
initialize
	super initialize.
	superclassEvaluated := false.
	metaSuperclassEvaluated := false.
	pendingMethods := OrderedDictionary new.
	category := 'Uncategorized'.
	organization := IdentityDictionary new.
	subclasses := #().