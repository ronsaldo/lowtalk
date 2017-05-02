initialization
setSymbol: aSymbol value: aValue ifPresent: aBlock
	symbols at: aSymbol ifPresent: aBlock ifAbsentPut: [ aValue ]