compiling
evaluateString: aString
	<compileTime>
	| ast stringEnvironment |
	ast := LowtalkParser parse: aString.
	stringEnvironment := LowtalkLocalEnvironment parent: globalEnvironment.
	^ LowtalkEvaluator evaluateValue: ast environment: stringEnvironment.