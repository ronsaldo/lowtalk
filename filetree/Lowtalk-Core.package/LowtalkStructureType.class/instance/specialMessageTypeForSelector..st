as yet unclassified
specialMessageTypeForSelector: selector
	environment ifNotNil: [
		environment lookSymbol: selector ifPresent: [ :member |
			^ member specialSelectorType
		]
	].

	^ super specialMessageTypeForSelector: selector
