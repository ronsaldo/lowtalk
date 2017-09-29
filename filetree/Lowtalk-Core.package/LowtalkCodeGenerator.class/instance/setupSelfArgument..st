top level entry points
setupSelfArgument: arg
	| debugVar |
	arg name: #self; makeReceiver.
	
	
	builder compilationTarget emittingDebugInformation ifTrue: [
		debugVar := SLVMDebugVariable scope: nil name: arg name.
		arg debugInformation: debugVar.
	]