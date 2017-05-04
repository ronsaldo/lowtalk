visiting
visitIdentifierReferenceNode: identifier
	^ environment lookSymbolRecursively: identifier value ifAbsent: [
		identifier environment: environment semanticError: 'Undeclared identifier {0}' format: { identifier value }
	]