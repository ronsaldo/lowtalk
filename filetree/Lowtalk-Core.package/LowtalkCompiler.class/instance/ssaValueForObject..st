as yet unclassified
ssaValueForObject: object
	^ objectSSAValueMap at: object ifAbsent: [ 
		(objectInstanceVariableMap at: object ifAbsent: [ self error: 'Expected an stored in a variable' ]) ssaValue
	]