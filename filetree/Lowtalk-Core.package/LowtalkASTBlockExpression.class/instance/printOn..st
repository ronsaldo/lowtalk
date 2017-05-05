printing
printOn: aStream
	aStream nextPutAll: '(closure ('.
	arguments do: [ :arg | aStream print: arg ].
	aStream nextPutAll: ') '; print: body; nextPutAll: ')'