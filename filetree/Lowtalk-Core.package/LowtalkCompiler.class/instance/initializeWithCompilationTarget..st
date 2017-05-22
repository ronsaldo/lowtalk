initialization
initializeWithCompilationTarget: aCompilationTarget
	compilationTarget := aCompilationTarget.
	objectModel := LowtalkObjectModel new compiler: self.
	self createEnvironment.
	currentDirectory := FileSystem workingDirectory.
	pendingObjects := Set new.