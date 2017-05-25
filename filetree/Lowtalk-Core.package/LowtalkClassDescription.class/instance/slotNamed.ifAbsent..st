slots
slotNamed: slotName ifAbsent: aBlock
	^ self slotDictionary at: slotName ifAbsent: [
		self superclass ifNil: aBlock ifNotNil: [ :superclass |
			superclass slotNamed: slotName ifAbsent: aBlock
		]
	]