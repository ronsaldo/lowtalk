printing
printOn: aStream
	aStream nextPutAll: '(seq'.
	expressions do: [ :expr |
		aStream cr; tab; print: expr
	].
	aStream nextPut: $)