messages
generateOrMessage: message receiver: receiver receiverType: receiverType
	| conditionType argument condition block startBlock mergeBlock continueBlock branch continueResult |
	block := message arguments first.
	condition := receiverType ssaConvert: receiver explicitlyTo: compiler booleanType with: builder at: message.

	startBlock := builder currentBlock.	
	mergeBlock := builder newBasicBlock: #orMerge.
	continueBlock := builder newBasicBlock: #orContinue.
	
	"Perform the branch"
	branch := builder branch: condition ifTrue: mergeBlock ifFalse: continueBlock.
	branch mergeBlock: mergeBlock.
	
	"Evaluate the inline block"
	builder currentBlock: continueBlock.
	continueResult := self inlineBlock: block arguments: #() types: #().
	builder jump: mergeBlock.
	

	self halt