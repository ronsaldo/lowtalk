as yet unclassified
cullInlineBlock: aBlockNode arguments: cullArguments types: cullArgumentTypes at: aNode
	| argumentCount |
	cullArguments size <  aBlockNode arguments size ifTrue: [ 
		aNode semanticError: 'Inlined block expects {1} arguments and receives {2} arguments'
			format: { aBlockNode arguments size asString . cullArguments size asString }
	].

	argumentCount := aBlockNode arguments size.
	^ self evaluateInlineBlock: aBlockNode arguments: (cullArguments first: argumentCount) types: (cullArgumentTypes first: argumentCount) at: aNode
