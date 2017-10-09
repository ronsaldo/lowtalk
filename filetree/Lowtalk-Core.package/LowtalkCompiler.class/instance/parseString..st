compiling
parseString: aString
	<compileTime>
	| ast contents |
	contents := aString asLowtalkCollectionWithContext.
	ast := LowtalkParser parse: contents.
	self convertParseFailure: ast collection: contents.
	^ ast