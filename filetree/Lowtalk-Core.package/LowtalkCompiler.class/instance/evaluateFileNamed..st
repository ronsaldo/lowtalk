compiling
evaluateFileNamed: aFileName
	| ast fileEnvironment result |
	ast := LowtalkParser parseFromFileNamed: aFileName.
	fileEnvironment := LowtalkEnvironment parent: globalEnvironment.
	result := ast evaluateInLowtalkEnvironment: fileEnvironment.
	^ result