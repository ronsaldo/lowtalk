object primitives
primitive_basicAt: index put: value
	| description |
	description := self behavior getClassDescription.
	^ slots at: description instanceSize + index put: value