slots
specialMessageTypeForSelector: selector
	self slotNamed: selector ifPresent: [ :slot | ^ slot specialSelectorType ].
	selector last = $: ifTrue: [ 
		self slotNamed: selector allButLast ifPresent: [ :slot | ^ slot setterSpecialSelectorType ].
	].

	^ super specialMessageTypeForSelector: selector
