as yet unclassified
generateFunction: ssaFunction value: functionValue
	| node result startArgument |
	node := functionValue definition node.
	method := functionValue definition.
	selfType := method receiverType.
	
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
	].

	method arguments doWithIndex: [ :arg :index |
		| ssaArgument |
		ssaArgument := ssaFunction arguments at: index + startArgument.
		ssaArgument name: arg name.
		arg ssaValue: ssaArgument.
	].

	method temporaries do: [ :temp |
		temp ssaValue: (allocaBuilder alloca: temp valueType ssaType name: temp name).
	].

	self flag: 'TODO: Initialize the temporary variables with 0 or nil.'.
	
	result := node body accept: self.
	
	allocaBuilder jump: bodyBlock.
	builder isLastTerminator ifFalse: [
		self tryToReturnImplicitly: result type: node body type
	].

	"Create the function context metadata"
	ssaFunction dynamicLiterals do: [ :literal | compiler convertDynamicObjectSSAConstant: literal value ]