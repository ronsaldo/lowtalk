coercions
ssaConvert: value explicitlyTo: targetType with: builder at: node
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asFloat.
	].
	
	^ super ssaConvert: value explicitlyTo: targetType with: builder at: node