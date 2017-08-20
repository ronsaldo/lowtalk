printing
printOn: aStream
	aStream nextPutAll: name asString; nextPutAll: ' -> '; print: value