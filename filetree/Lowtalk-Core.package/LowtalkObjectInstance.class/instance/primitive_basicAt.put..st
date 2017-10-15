object primitives
primitive_basicAt: index put: value
	| type |
	type := self behavior asClassType.
	^ slots at: type instanceSize + index put: value