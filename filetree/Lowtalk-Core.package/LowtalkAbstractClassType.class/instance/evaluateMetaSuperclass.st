superclass
evaluateMetaSuperclass
	metaSuperclassExpression ifNil: [ 
		metaSuperclass := self superclass metaClass
	] ifNotNil: [ 
		metaSuperclass := metaSuperclassExpression value.
		metaSuperclass ifNotNil: [ metaSuperclass asLowtalkTypeWith: compiler ]
	].
	metaSuperclassEvaluated := true
	