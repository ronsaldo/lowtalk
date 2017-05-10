messages
inlineBlock: node cull: arguments types: argumentTypes
	| usedArguments |
	usedArguments := node arguments size.
	self assert: usedArguments <= arguments size.
	
	^ self inlineBlock: node arguments: (arguments first: usedArguments) types: (argumentTypes first: usedArguments)