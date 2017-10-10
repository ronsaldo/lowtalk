visiting
visitIdentifierReferenceNode: node
	| binding |
	binding := node binding.
	node type isCompileTimeType ifTrue: [ 
		^ binding emitSSAVariableCompileTimeValueWith: self builder: builder at: node
	].

	node type isReferenceType ifTrue: [ 
		^ binding emitSSAVariableReferenceWith: self builder: builder at: node
	] ifFalse: [ 
		^ binding emitSSAVariableLoadWith: self builder: builder at: node
	].

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
	
		node binding isMethodVariable ifTrue: [ 
			self assert: node binding method isNotNil.
			self assert: node binding ssaValue isNotNil.
			node binding method ~~ method ifTrue: [ 
				^ self captureInClosure: node binding ssaValue
			].
		].
		^ node binding ssaValue
	].
	binding isNamespace ifTrue: [ 
		node type isCompileTimeType ifTrue: [ ^ binding ].
	].
	self halt.
	