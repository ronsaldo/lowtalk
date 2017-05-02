initialization
lookSymbolRecursively: symbol ifAbsent: aBlock
	symbols at: symbol ifPresent: [ :value | ^ value ].
	^ parent ifNil: [ aBlock value ] ifNotNil: [ parent lookSymbolRecursively: symbol ifAbsent: aBlock ]