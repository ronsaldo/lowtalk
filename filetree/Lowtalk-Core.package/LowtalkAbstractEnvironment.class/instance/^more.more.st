accessing method dictionary
>> aSymbol
	<compileTime>
	^ self lookSymbol: aSymbol ifAbsent: [ self error: 'Trying to access undefined symbol ' , aSymbol printString ]