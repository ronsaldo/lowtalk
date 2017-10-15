superclass
metaSuperclass
	metaSuperclassEvaluated ifFalse: [ self evaluateMetaSuperclass ].
	^ metaSuperclass