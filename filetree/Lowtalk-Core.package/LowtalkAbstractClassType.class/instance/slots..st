accessing
slots: slotsLazyValue
	<compileTime>
	<lazy>
	| baseEnvironment definitionEnvironment |
	slots ifNotNil: [ slotsLazyValue semanticError: 'Cannot redefine the slots of a structure.' ].

	baseEnvironment := slotsLazyValue environment.
	definitionEnvironment := baseEnvironment namespaceEnvironment.

	self
		environment: definitionEnvironment;
		slotsExpression: slotsLazyValue.