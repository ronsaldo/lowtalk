initialization
lookSymbolRecursively: symbol ifAbsent: aBlock
	self lookSymbol: symbol ifPresent: [ :value | ^ value ].
	^ parent ifNil: [ aBlock value ] ifNotNil: [ parent lookSymbolRecursively: symbol ifAbsent: aBlock ]