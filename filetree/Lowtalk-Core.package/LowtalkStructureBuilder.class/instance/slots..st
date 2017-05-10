building
slots: slotsLazyValue
	<compileTime>
	<lazy>
	| baseEnvironment structure definitionEnvironment |
	
	baseEnvironment := slotsLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.

	structure := LowtalkStructureType target: compiler compilationTarget.
	structure
		compiler: slotsLazyValue compiler;
		environment: baseEnvironment;
		slotsExpression: slotsLazyValue.
	
	^ structure