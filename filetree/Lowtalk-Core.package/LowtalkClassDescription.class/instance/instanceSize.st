accessing
instanceSize
	instanceSize ifNil: [ self slotDictionary ].
	^ instanceSize