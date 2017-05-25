accessing
lookSymbol: symbol ifAbsent: aBlock
	^ self convertSlot: (receiverType slotNamed: symbol ifAbsent: aBlock)