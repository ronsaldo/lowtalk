visiting
visitIdentifierReferenceNode: node
	| binding |
	binding := node binding.
	binding isVariable ifTrue: [
		binding isCompileTimeVariable ifTrue: [
			node type isReferenceType ifTrue: [ 
				^ compiler convertCapturedCompileTimeVariable: binding
			] ifFalse: [ 
				^ compiler convertDynamicObjectSSAConstant: binding value.
			].
		].
	
		binding isMethodReceiverSlot ifTrue: [
			^ builder getReference: selfValue element: (SLVMConstantValue int: binding description index)
		].
	
		^ node binding ssaValue
	].
	self halt.
	