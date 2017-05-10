as yet unclassified
specialMessageTypeForSelector: selector
	PointerMessages at: selector ifPresent: [:type | ^ type ].
	^ super specialMessageTypeForSelector: selector