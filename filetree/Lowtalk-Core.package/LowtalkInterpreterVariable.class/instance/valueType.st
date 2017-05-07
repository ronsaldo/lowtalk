accessing
valueType
	^ valueType ifNil: [ valueType := self resolveValueType ]