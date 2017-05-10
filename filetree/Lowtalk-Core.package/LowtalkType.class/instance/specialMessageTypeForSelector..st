special messages
specialMessageTypeForSelector: selector
	^ CommonSpecialMessages at: selector ifAbsent: [ nil ]