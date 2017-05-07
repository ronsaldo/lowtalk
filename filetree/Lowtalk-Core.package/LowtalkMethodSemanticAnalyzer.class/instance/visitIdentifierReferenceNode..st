visiting
visitIdentifierReferenceNode: identifier
	| result |
	result := environment lookSymbolRecursively: identifier value ifAbsent: [
		identifier environment: environment semanticError: 'Undeclared identifier {1}' format: { identifier value }
	].

	identifier binding: result.
	identifier type: result type.
	^ result