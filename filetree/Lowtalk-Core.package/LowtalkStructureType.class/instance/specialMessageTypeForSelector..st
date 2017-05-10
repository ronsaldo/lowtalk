slots
specialMessageTypeForSelector: selector
	self slots ifNotNil: [
		slots at: selector ifPresent: [ :slot | ^ slot specialSelectorType ]
	].

	^ super specialMessageTypeForSelector: selector
