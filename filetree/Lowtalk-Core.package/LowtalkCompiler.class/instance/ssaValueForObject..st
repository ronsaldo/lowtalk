as yet unclassified
ssaValueForObject: object
	^ objectSSAValueMap at: object ifAbsent: [ 
		(objectInstanceVariableMap at: object ifAbsent: [ self error: 'Expected a value stored in a variable' ]) ssaValue
	]