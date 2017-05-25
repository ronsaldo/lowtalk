accessing
receiverType
	parent ifNil: [ self error: 'No receiver available.' ].
	^ parent receiverType