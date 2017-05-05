accessing
mangledName
	self realParent ifNotNil: [ :realParent |
		^ realParent mangledName , (name size asString , name)
	] ifNil: [
		^ '_LT'
	]