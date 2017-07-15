accessing
fullName
	self realParent ifNotNil: [ :realParent |
		realParent realParent ifNil: [ ^ name ].
		^ realParent fullName , '>>' , name
	] ifNil: [
		^ name
	]