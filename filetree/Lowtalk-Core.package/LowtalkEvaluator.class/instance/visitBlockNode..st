visiting
visitBlockNode: aBlockNode
	(aBlockNode body hasPragmaNamed: #compileTimeOnly) ifTrue: [
		aBlockNode type: compiler objectType.
		^ LowtalkCompileTimeOnlyBlock new
			compiler: compiler;
			node: aBlockNode;
			environment: environment;
			yourself
	].

	aBlockNode definition ifNil: [
		aBlockNode definition: (LowtalkMethodSemanticAnalyzer new analyzeBlock: aBlockNode environment: environment).
	].

	^ aBlockNode definition closureWithEnvironment: environment
	