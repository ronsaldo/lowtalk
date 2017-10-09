visiting
visitIdentifierReferenceNode: identifier
	| result |
	result := (environment lookSymbolRecursively: identifier value ifAbsent: [
		identifier environment: environment semanticError: 'Undeclared identifier {1}' format: { identifier value }
	]) asLowtalkVariableReferenceFor: compiler.

	identifier setTypeIfNil: result type.
	^ identifier type isReferenceType ifTrue: [ result ] ifFalse: [ result value ]