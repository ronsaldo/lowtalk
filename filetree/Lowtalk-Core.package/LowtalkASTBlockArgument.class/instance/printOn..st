printing
printOn: aStream
	aStream nextPutAll: '('; nextPutAll: name; space; print: typeExpression; nextPutAll: ')'.