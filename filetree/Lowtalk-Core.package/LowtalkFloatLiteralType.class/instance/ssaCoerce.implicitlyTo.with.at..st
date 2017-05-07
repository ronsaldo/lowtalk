coercions
ssaCoerce: value implicitlyTo: targetType with: builder at: node
	targetType isFloatType ifTrue: [
		^ SLVMConstant type: targetType ssaType value: value asFloat.
	].
	
	^ super ssaCoerce: value implicitlyTo: targetType with: builder at: node