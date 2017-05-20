initialization
initializeWithCompilationTarget: aCompilationTarget
	compilationTarget := aCompilationTarget.
	objectModel := LowtalkObjectModel new.
	self createEnvironment.
	currentDirectory := FileSystem workingDirectory.
	pendingObjects := Set new.