printing
printOn: aStream
	name ifNotNil: [ 
		^ aStream nextPutAll: name
	].
	super printOn: aStream