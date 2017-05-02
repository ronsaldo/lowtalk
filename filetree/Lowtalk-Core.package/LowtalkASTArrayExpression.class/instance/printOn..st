printing
printOn: aStream
	aStream nextPutAll: '(array '; print: expressionList; nextPut:$)