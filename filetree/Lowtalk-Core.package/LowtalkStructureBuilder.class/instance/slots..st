building
slots: slotsLazyValue
	<compileTime>
	<lazy>
	| baseEnvironment structure definitionEnvironment |
	
	baseEnvironment := slotsLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.

	structure := LowtalkStructure parent: definitionEnvironment.
	structure slotsExpression: slotsLazyValue.
	
	^ structure