special messages
visitInlinedBlock: node cullTypes: expectedArgumentTypes from: parentNode
	| blockType  |
	
	"Try to infer some types in the inline block case"
	node isBlockNode ifTrue: [
		node arguments size > expectedArgumentTypes size ifTrue: [ 
			node semanticError: 'Block containts more arguments than the one that can receive'.
		].
		^ self visitInlinedBlock: node types: (expectedArgumentTypes first: node arguments size) from: parentNode
	].

	"Visit the inlined block"
	self visitInlinedBlock: node.
	
	"Check the called function signature."
	blockType := self extractInlinedBlockType: node.
	blockType isFunctionType ifTrue: [
		blockType arguments size > expectedArgumentTypes size ifTrue: [ 
			node semanticError: 'Function more arguments than the ones that can receive'.
		].
		self checkCall: blockType argumentTypes: (expectedArgumentTypes first: blockType arguments size) at: node
	]