as yet unclassified
generateFunction: ssaFunction value: functionValue
	| node result |
	node := functionValue node.
	method := functionValue.
	selfType := functionValue receiverType.
	
	"Create the builders"
	allocaBuilder := SLVMBuilder on: ssaFunction.
	builder := SLVMBuilder on: ssaFunction.
	
	allocaBlock := allocaBuilder newBasicBlock: #entry.
	allocaBuilder currentBlock: allocaBlock.
	
	bodyBlock := builder newBasicBlock: #body.
	builder currentBlock: bodyBlock.

	"Create the temporaries."
	functionValue arguments doWithIndex: [ :arg :index |
		| ssaArgument |
		ssaArgument := ssaFunction arguments at: index.
		ssaArgument name: arg name.
		arg ssaValue: ssaArgument.
	].

	functionValue temporaries do: [ :temp |
		temp ssaValue: (allocaBuilder alloca: temp valueType ssaType name: temp name).
	].

	self flag: 'TODO: Initialize the temporary variables with 0 or nil.'.
	
	result := node body accept: self.
	
	allocaBuilder jump: bodyBlock.
	builder isLastTerminator ifFalse: [
		self tryToReturnImplicitly: result type: node body type
	]
