as yet unclassified
generateInterpreterMethod: method closureEnvironment: closureEnvironment
	self flag: 'Do we need the closure environment?'.
	^ self generateInterpreterMethod: method
