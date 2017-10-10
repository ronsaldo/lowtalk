superclass
superclass
	^ self getClassDescription superclass ifNotNil: [ :co | co classObject asClassType ]