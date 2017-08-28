top level entry points
allocateTemporary: temp
	| value debugVar |
	value := allocaBuilder alloca: temp valueType ssaType name: temp name.
	temp ssaValue: value.
	
	builder compilationTarget emittingDebugInformation ifTrue: [
		debugVar := SLVMDebugVariable scope: nil name: temp name.
		value debugInformation: debugVar.
	]