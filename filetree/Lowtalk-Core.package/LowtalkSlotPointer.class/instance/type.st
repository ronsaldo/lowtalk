evaluating
type
	^ type ifNil: [type := self valueType ref]