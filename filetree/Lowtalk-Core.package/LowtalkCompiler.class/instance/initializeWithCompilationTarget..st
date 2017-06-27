initialization
initializeWithCompilationTarget: aCompilationTarget
	compilationTarget := aCompilationTarget.
	objectModel := LowtalkObjectModel new compiler: self.
	compilationTarget objectModel: (LowtalkSLVMObjectModel new compiler: self).
	self createEnvironment.
	currentDirectory := FileSystem workingDirectory.
	pendingObjects := Set new.
	
	objectInstanceVariableNameMap := IdentityDictionary new.
	metaclassVariableNameMap := IdentityDictionary new.
	objectSSAValueMap := IdentityDictionary new.
	objectInstanceVariableMap := IdentityDictionary new.
	unmangledSymbolMap := IdentityDictionary new.
	debugLocationDictionary := Dictionary new.
	debugSourceFileDictionary := IdentityDictionary new.
	capturedCompileTimeVariables := IdentityDictionary new.
	gensymCount := 0.