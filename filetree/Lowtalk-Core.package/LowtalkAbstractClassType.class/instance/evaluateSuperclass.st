superclass
evaluateSuperclass
	superclassExpression ifNil: [ 
		superclass := self defaultSuperclass asLowtalkTypeWith: compiler
	] ifNotNil: [ 
		superclass := superclassExpression value.
		superclass ifNotNil: [ superclass asLowtalkTypeWith: compiler ]
	].
	(superclass isNotNil and: [ self isMetaClass not ]) ifTrue: [
		superclass addSubclass: self
	].
	
	superclassEvaluated := true
	