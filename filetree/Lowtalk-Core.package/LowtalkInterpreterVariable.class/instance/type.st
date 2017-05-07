accessing
type
	^ type ifNil: [ type := self resolveType ]