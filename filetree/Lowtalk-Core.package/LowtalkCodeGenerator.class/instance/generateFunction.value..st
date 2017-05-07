as yet unclassified
generateFunction: ssaFunction value: functionValue
	| node |
	node := functionValue node.
	method := functionValue.
	receiverType := functionValue receiverType.
	
	functionValue arguments doWithIndex: [ :arg :index |
		| ssaArgument |
		ssaArgument := ssaFunction arguments at: index.
		ssaArgument name: arg name.
		arg value: ssaArgument.
	].

	allocaBuilder := SLVMBuilder on: ssaFunction.
	builder := SLVMBuilder on: ssaFunction.

	allocaBlock := allocaBuilder newBasicBlock: #entry.
	allocaBuilder currentBlock: allocaBlock.
	
	bodyBlock := builder newBasicBlock: #body.
	builder currentBlock: bodyBlock.
	
	node body accept: self.
	
	allocaBuilder jump: bodyBlock.
	builder isLastTerminator ifFalse: [
		self tryToReturnImplicitly.
	]
