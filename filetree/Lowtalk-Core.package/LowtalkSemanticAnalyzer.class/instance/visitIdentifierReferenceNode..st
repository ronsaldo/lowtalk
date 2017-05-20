visiting
visitIdentifierReferenceNode: identifier
	| result |
	result := environment lookSymbolRecursively: identifier value ifAbsent: [
		identifier environment: environment semanticError: 'Undeclared identifier {1}' format: { identifier value }
	].

	identifier type ifNil: [ identifier type: result type ].
	^ identifier type isReferenceType ifTrue: [ result ] ifFalse: [ result value ]