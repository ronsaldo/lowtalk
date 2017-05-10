special messages
visitInlinedBlock: node types: expectedArgumentTypes from: parentNode
	| blockType knownArguments argument |
	
	"Set some types for type inference"
	node isBlockNode ifTrue: [
		knownArguments := node arguments size min: expectedArgumentTypes size.
		1 to: knownArguments do: [ :index |
			argument := node arguments at: index.
			(argument type isNil and: [argument typeExpression isNil]) ifTrue: [ 
				argument type: (expectedArgumentTypes at: index)
			]
		].
	].

	"Visit the inlined block"
	self visitInlinedBlock: node.
	
	"Check the called function signature."
	blockType := self extractInlinedBlockType: node.
	blockType isFunctionType ifTrue: [
		self checkCall: blockType argumentTypes: expectedArgumentTypes at: parentNode
	]