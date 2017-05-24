compiling
evaluateString: aString
	<compileTime>
	| ast stringEnvironment contents |
	contents := aString asLowtalkCollectionWithContext.
	ast := LowtalkParser parse: contents.
	self convertParseFailure: ast collection: contents.
	stringEnvironment := LowtalkLocalEnvironment parent: globalEnvironment.
	^ LowtalkEvaluator evaluateValue: ast environment: stringEnvironment.