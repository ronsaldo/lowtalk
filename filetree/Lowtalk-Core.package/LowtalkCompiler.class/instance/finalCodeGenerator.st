accessing
finalCodeGenerator
	^ finalCodeGenerator ifNil: [ finalCodeGenerator := compilationTarget createCodeGenerator
		optimizationLevel: optimizationLevel;
		yourself ]