accessing
valueType
	valueType ifNil: [ self resolveType ].
	^ valueType