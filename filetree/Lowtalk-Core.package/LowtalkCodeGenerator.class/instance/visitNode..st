visiting
visitNode: node
	"Keep track of the debug position"
	| debugPosition result |
	builder compilationTarget emittingDebugInformation ifTrue: [
		debugPosition := compiler convertDebugPosition: node position.
		builder pushDebugSourcePosition: debugPosition.
		allocaBuilder pushDebugSourcePosition: debugPosition.
		
		[
			result := super visitNode: node.
		] ensure: [
			builder popDebugSourcePosition.
			allocaBuilder popDebugSourcePosition.
		].
	
		^ result
	].

	^ super visitNode: node
