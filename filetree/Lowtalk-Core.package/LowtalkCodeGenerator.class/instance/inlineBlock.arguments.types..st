messages
inlineBlock: node arguments: arguments types: argumentTypes
	| expectedArguments binding |
	expectedArguments := node arguments.
	node arguments doWithIndex: [ :argument :index |
		binding := argument binding.
		binding ssaValue: (self coerceImplicitly: (arguments at: index) type: (argumentTypes at: index) to: binding type at: node).
	].

	^ self visitNode: node body