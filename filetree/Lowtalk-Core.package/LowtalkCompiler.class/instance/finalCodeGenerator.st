accessing
finalCodeGenerator
	^ finalCodeGenerator ifNil: [ finalCodeGenerator := compilationTarget createCodeGenerator ]