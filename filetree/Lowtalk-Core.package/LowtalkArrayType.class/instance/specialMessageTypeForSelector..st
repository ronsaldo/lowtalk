special messages
specialMessageTypeForSelector: selector
	ArrayMessages at: selector ifPresent: [:type | ^ type ].
	^ super specialMessageTypeForSelector: selector