special messages
specialMessageTypeForSelector: selector
	ReferenceMessages at: selector ifPresent: [:type | ^ type ].
	^ super specialMessageTypeForSelector: selector