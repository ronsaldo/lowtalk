special messages
specialMessageTypeForSelector: selector
	(instanceType specialMessageTypeForMetaSelector: selector) ifNotNil: [ :result |
		^ result
	].

	^ super specialMessageTypeForSelector: selector