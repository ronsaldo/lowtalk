initialization
createSlotNamedOverrideSelector: selector receiver: receiver arguments: arguments inSuperclass: theSuperclass node: node
	| slotType |
	slotType := arguments first value.
	^ slotType slot name: receiver 