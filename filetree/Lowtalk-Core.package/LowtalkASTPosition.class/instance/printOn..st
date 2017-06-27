accessing
printOn: aStream
	aStream nextPutAll: self fileName; nextPut: $:; print: self line; nextPut: $:; print: self column 