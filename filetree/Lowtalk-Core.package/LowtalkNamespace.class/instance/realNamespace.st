accessing
realNamespace
	^ compileTimeOnly ifTrue: [ nil ] ifFalse: [ self ]