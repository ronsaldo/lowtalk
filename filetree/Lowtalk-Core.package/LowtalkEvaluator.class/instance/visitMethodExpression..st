visiting
visitMethodExpression: aMethodNode
	aMethodNode setTypeIfNil: compiler objectType.
	^ LowtalkInterpreterMethodExpression new
		node: aMethodNode;
		environment: environment;
		compiler: self compiler;
		yourself