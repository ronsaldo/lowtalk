initialization
initialize
	super initialize.
	callingConvention := SLVMFunctionType smalltalkCallingConvention.
	variadic := false.
	readOnly := true.