compiling
initialize
	super initialize.
	self createEnvironment.
	currentDirectory := FileSystem workingDirectory.