overrides
createSlotNamedOverrideSelector: selector receiver: receiver arguments: arguments inSuperclass: theSuperclass node: node compiler: aCompiler
	| slotType |
	slotType := arguments first value.
	^ slotType slot name: receiver 