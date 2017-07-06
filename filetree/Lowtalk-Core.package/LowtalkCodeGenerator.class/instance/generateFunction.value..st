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
	
	result := self visitNode: node body.
	
	allocaBuilder jump: bodyBlock.
	builder isLastTerminator ifFalse: [
		method hasLocalReturns ifTrue: [ 
			self tryToReturnImplicitly: selfValue type: selfType
		] ifFalse: [ 
			self tryToReturnImplicitly: result type: node body type
		]

	].

	(method selector isNotNil or:
	[ (method methodClass classBindingWithCompiler: compiler) isNotNil
	or: [ ssaFunction dynamicLiterals isNotEmpty ]]) ifTrue: [ 
		ssaFunction
			addRequiredDynamicLiteral: method selector;
			addRequiredDynamicLiteral: (method methodClass classBindingWithCompiler: compiler).

	].
	
	"Create the function context metadata"
	ssaFunction dynamicLiterals do: [ :literal | compiler convertDynamicObjectSSAConstant: literal value ]