compiling
doEvaluateFileNamed: aFileName inContext: aLowtalkContext
	| ast result fileReference oldDirectory contents |
	fileReference := currentDirectory resolve: aFileName asFileReference.
	oldDirectory := currentDirectory.
	currentDirectory := fileReference parent.

	[ 
		contents := fileReference contents asLowtalkCollectionWithContext.
		contents name: fileReference fullName.

		ast := LowtalkParser parse: contents.
		self convertParseFailure: ast collection: contents.
		result := LowtalkEvaluator evaluateValue: ast environment: aLowtalkContext.
		^ result
	] ensure: [  currentDirectory := oldDirectory ]
