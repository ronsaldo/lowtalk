accessing
printOn: aStream
	aStream nextPutAll: collection name; nextPut: $:; print: self line; nextPut: $:; print: self column 