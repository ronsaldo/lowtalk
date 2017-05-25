accessing
receiverTypeOr: defaultType
	^ parent ifNotNil: [parent receiverTypeOr: defaultType ] ifNil: [defaultType]