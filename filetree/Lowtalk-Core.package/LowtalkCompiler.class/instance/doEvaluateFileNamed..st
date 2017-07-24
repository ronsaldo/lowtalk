compiling
doEvaluateFileNamed: aFileName
	<compileTime>
	| ast fileEnvironment result fileReference oldDirectory contents |
	fileReference := currentDirectory resolve: aFileName asFileReference.
	oldDirectory := currentDirectory.
	currentDirectory := fileReference parent.

	[ 
		contents := fileReference contents asLowtalkCollectionWithContext.
		contents name: fileReference fullName.

		ast := LowtalkParser parse: contents.
		self convertParseFailure: ast collection: contents.
		fileEnvironment := LowtalkLocalEnvironment parent: globalEnvironment.
		result := LowtalkEvaluator evaluateValue: ast environment: fileEnvironment.
		^ result
	] ensure: [  currentDirectory := oldDirectory ]
