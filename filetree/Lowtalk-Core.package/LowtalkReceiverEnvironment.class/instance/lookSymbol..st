accessing
lookSymbol: symbol
	^ self lookSymbol: symbol ifAbsent: [ self error: 'Symbol not found.' ]