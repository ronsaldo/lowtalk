special messages
specialMessageTypeForSelector: selector
	BlockSpecialMessages at: selector ifPresent: [ :type | ^ type ].
	^ super specialMessageTypeForSelector: selector