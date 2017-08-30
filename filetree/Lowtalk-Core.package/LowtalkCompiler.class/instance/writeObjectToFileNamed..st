front end
writeObjectToFileNamed: aFileName
	| lowLevelModule |
	self buildModule;
		ssaModule.
	
	optimizationLevel > 0 ifTrue: [ 
		ssaModule optimizeGlobalVariables
	].

	lowLevelModule := ssaModule asLowLevelModuleWithOptimizationLevel: optimizationLevel.
	lowLevelModule asBinaryObject writeObjectToFileNamed: aFileName