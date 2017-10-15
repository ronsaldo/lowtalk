object primitives
primitive_basicAt: index
	| type |
	type := self behavior asClassType.
	^ slots at: type instanceSize + index