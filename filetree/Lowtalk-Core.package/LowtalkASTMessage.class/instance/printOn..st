printing
printOn: aStream
	aStream nextPutAll: '(send '; print: selector.
	receiver ifNotNil: [ aStream space; print: receiver].
	arguments do: [ :arg |
		aStream space; print: arg
	].
	aStream nextPut: $)