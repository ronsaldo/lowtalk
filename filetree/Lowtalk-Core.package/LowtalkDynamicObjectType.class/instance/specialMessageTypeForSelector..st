special messages
specialMessageTypeForSelector: selector
	DynamicObjectSpecialMessages at: selector ifPresent: [ :type | ^ type ].
	^ super specialMessageTypeForSelector: selector