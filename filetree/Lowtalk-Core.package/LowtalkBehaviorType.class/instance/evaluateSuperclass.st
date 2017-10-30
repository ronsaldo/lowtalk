superclass
evaluateSuperclass
	(superclass isNotNil and: [ self isMetaClass not ]) ifTrue: [
		superclass addSubclass: self
	].