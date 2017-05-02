as yet unclassified
evaluateInLowtalkEnvironment: anEnvironment
	^ anEnvironment lookSymbolRecursively: value ifAbsent: [
		self environment: anEnvironment semanticError: 'Undeclared identifier {0}' format: { value }
	]