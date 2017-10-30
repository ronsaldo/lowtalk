special messages
specialMessageTypeForSelector: selector
	SpecificClassObjectSpecialMessages at: selector ifPresent: [ :type | ^ type ].
	^ super specialMessageTypeForSelector: selector