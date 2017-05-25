accessing
receiver
	parent ifNil: [ self error: 'No receiver available.' ].
	^ parent receiver