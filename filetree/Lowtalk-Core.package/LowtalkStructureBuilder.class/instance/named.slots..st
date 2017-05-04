building
named: nameLazyValue slots: slotsLazyValue
	<compileTime>
	<lazy>
	| name baseEnvironment definitionEnvironment structure |
	name := nameLazyValue value.

	baseEnvironment := slotsLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.

	structure := self slots: slotsLazyValue.
	structure name: name.
	definitionEnvironment setSymbol: name value: structure ifPresent: [ 
		nameLazyValue node semanticError: 'Symbol {1} is already used' format: { name printString }
	].
	
	^ structure