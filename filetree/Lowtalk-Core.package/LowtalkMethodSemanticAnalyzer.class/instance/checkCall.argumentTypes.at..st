visiting
checkCall: functionType argumentTypes: argumentTypes at: node
	(argumentTypes size < functionType arguments size or:
	[argumentTypes size > functionType arguments size and: [ functionType variadic not ]]) ifTrue: [ 
		node semanticError: 'Mismatching number of arguments for function of type {1}.' format: { functionType name }.
	].

	"Check the type of the argumetns"
	functionType arguments doWithIndex: [ :expectedType :index |
		(argumentTypes at: index) implicitlyConvertedTo: expectedType at: node.
	].