slots
specialMessageTypeForSelector: selector
	self slots ifNotNil: [
		slots at: selector ifPresent: [ :slot | ^ slot specialSelectorType ].
		selector last = $: ifTrue: [ 
			slots at: selector allButLast ifPresent: [ :slot | ^ slot setterSpecialSelectorType ].
		]
	].

	^ super specialMessageTypeForSelector: selector
