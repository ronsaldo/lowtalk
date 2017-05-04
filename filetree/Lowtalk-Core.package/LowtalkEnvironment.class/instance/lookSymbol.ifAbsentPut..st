initialization
lookSymbol: symbol ifAbsentPut: aBlock
	^ symbols at: symbol ifAbsentPut: aBlock