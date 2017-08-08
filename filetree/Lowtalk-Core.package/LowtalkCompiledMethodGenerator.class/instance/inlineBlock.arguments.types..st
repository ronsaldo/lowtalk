visiting
inlineBlock: potentialBlockNode arguments: arguments types: types
	| selector arg argumentValueType |
	potentialBlockNode isBlockNode ifFalse: [
		selector := String streamContents: [ :out |
			(1 to: arguments) do: [ out nextPutAll: 'value:' ]
		].
		selector := selector asSymbol.
		self halt.
	].
	
	potentialBlockNode arguments size to: 1 by: -1 do: [ :index |
		arg := potentialBlockNode arguments at: index.
		self assert: arg binding isInlineArgument.
		argumentValueType := types at: index.
		self coerceImplicitlyFrom: argumentValueType to: arg binding valueType at: potentialBlockNode.
		arg binding irStoreStackTopWith: irBuilder.
		irBuilder
			popTop
	].

	self visitNode: potentialBlockNode body.
	self coerceImplicitlyFrom: potentialBlockNode body type to: potentialBlockNode returnType at: potentialBlockNode
