visiting
withMethod: newMethod do: aBlock
	| oldMethod |
	oldMethod := method.
	method := newMethod.
	aBlock ensure: [
		method := oldMethod
	]