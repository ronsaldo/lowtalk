accessing
type
	^ type ifNil: [ type := self buildType ].