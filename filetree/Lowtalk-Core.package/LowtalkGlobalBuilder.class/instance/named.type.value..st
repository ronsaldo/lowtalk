as yet unclassified
named: nameLazyValue type: typeLazyValue value: lazyValue
	<compileTime>
	<lazy>
	
	| baseEnvironment definitionEnvironment name global |
	name := nameLazyValue value.
	
	baseEnvironment := nameLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.
	
	global := LowtalkGlobalVariable new
		name: name;
		definitionEnvironment: definitionEnvironment;
		compiler: definitionEnvironment compiler;
		typeExpression: typeLazyValue asTypeExpression;
		valueExpression: lazyValue.
	definitionEnvironment setSymbol: name value: global ifPresent: [ 
		nameLazyValue node semanticError: 'Symbol {1} is already used.' format: { name printString }
	].

	compiler addPendingObject: global.
	^ global