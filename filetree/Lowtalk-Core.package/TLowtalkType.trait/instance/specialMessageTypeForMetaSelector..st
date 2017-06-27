special messages
specialMessageTypeForMetaSelector: selector
	^ LowtalkTypeSharedPool commonTypeSpecialMessages at: selector ifAbsent: [ nil ]