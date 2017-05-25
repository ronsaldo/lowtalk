accessing
lookSymbol: symbol ifPresent: aBlock
	receiverType slotNamed: symbol ifPresent: [:slot |
		aBlock value: (self convertSlot: slot)
	]