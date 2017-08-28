top level entry points
generateFunction: ssaFunction value: functionValue
	| node startArgument |
	node := functionValue definition node.
	method := functionValue definition.
	selfType := method receiverType.
	method ssaFunction: ssaFunction.
	currentFunction := ssaFunction.
	
	"Create the builders"
	allocaBuilder := SLVMBuilder on: ssaFunction.
	builder := SLVMBuilder on: ssaFunction.
	
	allocaBlock := allocaBuilder newBasicBlock: #entry.
	allocaBuilder currentBlock: allocaBlock.
	
	bodyBlock := builder newBasicBlock: #body.
	builder currentBlock: bodyBlock.

	"Create the temporaries."
	startArgument := 0.
	selfType isVoidType ifFalse: [ 
		startArgument := 1.
		selfValue := ssaFunction arguments first.
		method receiverSSAValue: selfValue.
	].

	method arguments doWithIndex: [ :arg :index |
		| ssaArgument |
		ssaArgument := ssaFunction arguments at: index + startArgument.
		self setupArgument: arg withValue: ssaArgument.
	].

	method temporaries do: [ :temp |
		self allocateTemporary: temp
	].

	self flag: 'TODO: Initialize the temporary variables with 0 or nil.'.
	
	self generateFunctionBody: node body.