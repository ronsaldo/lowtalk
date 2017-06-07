visiting
visitIdentifierReferenceNode: node
	| binding result |
	binding := node binding.
	binding isVariable ifTrue: [
		binding isInterpreterVariable ifTrue: [ 
			result := compiler convertDynamicObjectSSAConstant: binding value.
			self halt
		].
	
		binding isMethodReceiverSlot ifTrue: [
			^ builder getReference: selfValue element: (SLVMConstantValue int: binding description index - 1)
		].
	
		^ node binding ssaValue
	].
	self halt.
	