slots
slotNamed: slotName ifPresent: aBlock
	^ self slotDictionary at: slotName ifPresent: aBlock ifAbsent: [
		self superclass ifNotNil: [:superclass |
			^ superclass slotNamed: slotName ifPresent: aBlock
		 ]
	]