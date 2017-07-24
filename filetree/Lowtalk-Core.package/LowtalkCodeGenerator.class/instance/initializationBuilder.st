top level entry points
initializationBuilder
	initializationBuilder ifNotNil: [ ^ initializationBuilder ].
	
	initializationBuilder := SLVMBuilder on: currentFunction .
	initializationBlock := allocaBuilder newBasicBlock: #initialization.
	initializationBuilder currentBlock: initializationBlock.
	
	^ initializationBuilder
