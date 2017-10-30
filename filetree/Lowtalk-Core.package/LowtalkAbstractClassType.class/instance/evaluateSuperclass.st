superclass
evaluateSuperclass
	superclassExpression ifNil: [ 
		superclass := self defaultSuperclass asLowtalkTypeWith: compiler
	] ifNotNil: [ 
		superclass := superclassExpression value.
		superclass ifNotNil: [ superclass asLowtalkTypeWith: compiler ]
	].

	superclassEvaluated := true
	