visiting
visitBlockNode: aBlockNode
	aBlockNode definition ifNil: [
		aBlockNode definition: (LowtalkMethodSemanticAnalyzer new analyzeBlock: aBlockNode environment: environment).
	].

	^ aBlockNode definition closureWithEnvironment: environment
	