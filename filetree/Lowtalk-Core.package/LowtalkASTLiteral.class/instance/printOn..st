printing
printOn: aStream
	aStream nextPutAll: '(literal '; print: value;  nextPut: $)