as yet unclassified
pendingMethod: interpreterMethod category: categoryName
	| compiledMethod |
	self flag: 'Make this process lazier.'.
	compiledMethod := compiler generateCompiledMethod: interpreterMethod.
	self halt