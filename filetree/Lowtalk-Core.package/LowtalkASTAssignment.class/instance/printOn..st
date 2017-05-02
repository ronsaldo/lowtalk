printing
printOn: aStream
	aStream nextPutAll: '(assign '; print: reference; space; print: value; nextPut: $)