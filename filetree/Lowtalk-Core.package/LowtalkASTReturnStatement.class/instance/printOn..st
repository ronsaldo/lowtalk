printing
printOn: aStream
	aStream nextPutAll: '(return '; print: value; nextPut: $)