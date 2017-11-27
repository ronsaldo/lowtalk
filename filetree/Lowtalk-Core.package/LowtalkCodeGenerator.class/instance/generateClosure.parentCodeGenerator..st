top level entry points
generateClosure: node parentCodeGenerator: aParentCodeGenerator
	| capturedSelf functionType ssaFunction startArgument passedSelfType |
	parentCodeGenerator := aParentCodeGenerator.
	method := node definition.
	passedSelfType := method receiverType.
	capturedSelf := self findCapturedReceiver.
	
	self assert: node type isBlockType.
	functionType := node type functionType.
	
	currentFunction := ssaFunction := SLVMClosureDefinition module: compiler ssaModule functionType: functionType ssaType.
	ssaFunction makePrivate.
	ssaFunction gcStrategy: #lowtalk.
	method definition ssaFunction: ssaFunction.
	
	"Create the builders"
	allocaBuilder := SLVMBuilder on: ssaFunction.
	builder := SLVMBuilder on: ssaFunction.
	builder allocaBuilder: allocaBuilder.
	
	allocaBlock := allocaBuilder newBasicBlock: #entry.
	allocaBuilder currentBlock: allocaBlock.
	
	bodyBlock := builder newBasicBlock: #body.
	builder currentBlock: bodyBlock.
	
	"Create the temporaries."
	startArgument := 0.
	passedSelfType isVoidType ifTrue: [
		capturedSelf ifNotNil: [
			selfType := capturedSelf first.
			selfValue := self captureInClosure: capturedSelf second.
		] ifNil: [ 
			selfType := passedSelfType.
			selfValue := nil
		]
	] ifFalse: [ 
		startArgument := 1.
		selfType := passedSelfType.
		selfValue := ssaFunction arguments first.
		method receiverSSAValue: selfValue.
	].

	method arguments doWithIndex: [ :arg :index |
		| ssaArgument |
		ssaArgument := ssaFunction arguments at: index + startArgument.
		self setupArgument: arg withValue: ssaArgument
	].

	method temporaries do: [ :temp |
		self allocateTemporary: temp
	].

	self flag: 'TODO: Initialize the temporary variables with 0 or nil.'.
	
	self generateFunctionBody: node body.
	
	^ {ssaFunction . capturedValues}