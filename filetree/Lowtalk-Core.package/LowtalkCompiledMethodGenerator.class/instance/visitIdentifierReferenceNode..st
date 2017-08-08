visiting
visitIdentifierReferenceNode: node
	| binding |
	binding := node binding.
	binding isVariable ifTrue: [
		binding isCompileTimeVariable ifTrue: [
			node type isReferenceType ifTrue: [ 
				^ irBuilder pushLiteral: binding
			] ifFalse: [ 
				self halt
			].
		].
	
		binding isMethodReceiverSlot ifTrue: [
			node type isReferenceType ifTrue: [
				^ irBuilder
					pushReceiver;
					pushLiteral: binding description;
					send: #pointerForSlotDescription:
			] ifFalse: [
				self halt.
			]
		].
	
		node binding isMethodVariable ifTrue: [ 
			self assert: node binding method isNotNil.
			self assert: node binding compiledMethodVariable isNotNil.
			node binding method ~~ method ifTrue: [ 
				^ self captureInClosure: node binding ssaValue
			].
			^ irBuilder pushTemp: node binding compiledMethodVariable
		].
	
		^ irBuilder pushLiteral: binding
	].

	binding isNamespace ifTrue: [ 
		node type isCompileTimeType ifTrue: [ ^ irBuilder pushLiteral: binding ].
	].
	self halt