initialization
initializeWithCompilationTarget: aCompilationTarget
	compilationTarget := aCompilationTarget.
	profilingInterpreter := false.
	objectModel := LowtalkObjectModel new compiler: self.
	compilationTarget objectModel: (LowtalkSLVMObjectModel new compiler: self).
	self createEnvironment.
	self gatherLazySelectors.
	currentDirectory := FileSystem workingDirectory.
	pendingObjects := SLVMOrderedInsertionSet new.
	self addPendingObject: globalEnvironment.
	
	objectInstanceVariableNameMap := IdentityDictionary new.
	metaclassVariableNameMap := IdentityDictionary new.
	objectSSAValueMap := IdentityDictionary new.
	objectInstanceVariableMap := IdentityDictionary new.
	unmangledSymbolMap := IdentityDictionary new.
	debugLocationDictionary := Dictionary new.
	debugSourceFileDictionary := IdentityDictionary new.
	capturedCompileTimeVariables := IdentityDictionary new.
	gensymCount := 0.