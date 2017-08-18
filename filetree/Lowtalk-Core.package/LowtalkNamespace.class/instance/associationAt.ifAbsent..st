accessing
associationAt: aName ifAbsent: aBlock
	<compileTime>
	^ self lookSymbol: aName ifAbsent: aBlock