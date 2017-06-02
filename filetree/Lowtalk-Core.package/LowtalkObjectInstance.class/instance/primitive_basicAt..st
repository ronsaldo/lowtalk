object primitives
primitive_basicAt: index
	| description |
	description := self behavior getClassDescription.
	^ slots at: description instanceSize + index