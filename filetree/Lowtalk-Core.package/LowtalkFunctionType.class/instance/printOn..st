printing
printOn: aStream
	aStream nextPutAll: '('.
	arguments doWithIndex: [ :arg :index |
		index > 1 ifTrue: [ 
			aStream nextPutAll: ', '.
		].
		aStream print: arg
	].

	aStream nextPutAll: ') -> '; print: returnType.