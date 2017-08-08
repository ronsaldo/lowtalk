accessing
type
	^ type ifNil: [type := node type withoutReferences]