special messages
specialMessageTypeForSelector: selector
	ThisContextSpecialMessageTypes at: selector ifPresent: [ :result | ^ result ].

	^ super specialMessageTypeForSelector: selector