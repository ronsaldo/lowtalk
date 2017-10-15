accessing
createRawObjectOfLayoutType: aLayoutType size: aSize
	^ compiler objectModel perform: (NewObjectForType at: aLayoutType) with: aSize