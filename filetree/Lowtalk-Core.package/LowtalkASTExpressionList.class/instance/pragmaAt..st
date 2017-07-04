enumerating
pragmaAt: aPragmaName
	^ self pragmaAt: aPragmaName ifAbsent: [self error: 'Failed to find pragma']