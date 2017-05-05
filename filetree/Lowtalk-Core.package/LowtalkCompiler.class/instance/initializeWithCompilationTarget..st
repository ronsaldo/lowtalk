initialization
initializeWithCompilationTarget: aCompilationTarget
	compilationTarget := aCompilationTarget.
	self createEnvironment.
	currentDirectory := FileSystem workingDirectory.
	pendingObjects := Set new.