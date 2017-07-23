coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isIntegerType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asInteger.
	].
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asInteger asFloat.
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node