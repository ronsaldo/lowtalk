special messages
specialMessageTypeForMetaSelector: selector
	StructureMetaMessageTypes at: selector ifPresent: [ :type | ^ type ].

	^ super specialMessageTypeForMetaSelector: selector