superclass
superclass
	classObject ifNotNil: [
		^ self getClassDescription superclass ifNotNil: [ :co | co classObject asClassType ].
	].

	^ super superclass