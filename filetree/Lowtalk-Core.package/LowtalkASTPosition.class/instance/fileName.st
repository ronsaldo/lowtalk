accessing
fileName
	^ collection ifNil: ['generated'] ifNotNil: [collection name]