accessing
buildSSAType
	^ SLVMFunctionType callingConvention: callingConvention arguments: (arguments collect: #ssaType) returnType: returnType ssaType