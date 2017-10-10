methods
installMethod: aMethod category: methodCategory
	| compiledMethod |
	compiledMethod := compiler generateCompiledMethod: aMethod.
	"self classObject methodDict at: compiledMethod selector put: compiledMethod"
	classObject addAndClassifySelector: compiledMethod selector
		withMethod: compiledMethod
		inProtocol: methodCategory 
		notifying: nil.
	classObject instanceSide 
		noteCompilationOfMethod: compiledMethod 
		meta: classObject isClassSide.