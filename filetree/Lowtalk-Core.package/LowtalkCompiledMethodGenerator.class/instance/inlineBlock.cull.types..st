visiting
inlineBlock: potentialBlockNode cull: optionalArguments types: types
	| selector discardedArguments |
	potentialBlockNode isBlockNode ifFalse: [
		selector := String streamContents: [ :out |
			(1 to: optionalArguments) do: [ out nextPutAll: 'cull:' ]
		].
		selector := selector asSymbol.
		self halt.
	].
	
	discardedArguments := optionalArguments - potentialBlockNode arguments size.
	1 to: discardedArguments do: [ :i | irBuilder popTop ].
	
	self inlineBlock: potentialBlockNode arguments: potentialBlockNode arguments types: (types first: potentialBlockNode arguments size)