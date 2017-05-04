compiling
evaluateFileNamed: aFileName
	<compileTime>
	| ast fileEnvironment result fileReference oldDirectory |
	fileReference := currentDirectory resolve: aFileName asFileReference.
	oldDirectory := currentDirectory.
	currentDirectory := fileReference parent.

	[ 
		ast := LowtalkParser parseFromFileNamed: fileReference.
		fileEnvironment := LowtalkLocalEnvironment parent: globalEnvironment.
		result := LowtalkEvaluator evaluate: ast environment: fileEnvironment.
		^ result
	] ensure: [  currentDirectory := oldDirectory ]
