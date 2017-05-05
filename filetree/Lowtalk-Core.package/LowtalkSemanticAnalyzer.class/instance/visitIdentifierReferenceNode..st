visiting
visitIdentifierReferenceNode: identifier
	| result |
	identifier binding ifNotNil: [ :binding | ^ binding ].
	
	result := environment lookSymbolRecursively: identifier value ifAbsent: [
		identifier environment: environment semanticError: 'Undeclared identifier {1}' format: { identifier value }
	].

	identifier
		binding: result;
		type: result type.
	^ result