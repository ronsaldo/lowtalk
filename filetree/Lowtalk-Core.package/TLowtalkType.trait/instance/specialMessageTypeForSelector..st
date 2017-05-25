special messages
specialMessageTypeForSelector: selector
	^ LowtalkTypeSharedPool commonSpecialMessages at: selector ifAbsent: [ nil ]