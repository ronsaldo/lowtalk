compiling
doEvaluateFileNamed: aFileName
	| fileEnvironment |
	fileEnvironment := LowtalkLocalEnvironment parent: globalEnvironment.
	self doEvaluateFileNamed: aFileName inContext: fileEnvironment