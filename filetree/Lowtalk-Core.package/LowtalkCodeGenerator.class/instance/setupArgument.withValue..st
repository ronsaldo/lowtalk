top level entry points
setupArgument: arg withValue: value
	| debugVar |
	value name: arg name.
	arg ssaValue: value.
	
	builder compilationTarget emittingDebugInformation ifTrue: [
		debugVar := SLVMDebugVariable scope: nil name: arg name.
		value debugInformation: debugVar.
	]