printing
printOn: aStream
	aStream nextPutAll: name asString; nextPutAll: ' -> '; print: self rawValue