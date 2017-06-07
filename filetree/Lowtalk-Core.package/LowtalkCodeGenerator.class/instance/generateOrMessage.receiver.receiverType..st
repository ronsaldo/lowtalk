messages
generateOrMessage: message receiver: receiver receiverType: receiverType
	| condition block startBlock mergeBlock continueBlock branch continueResult blockType blockResultType conditionResult phi |
	block := message arguments first.
	condition := receiverType ssaConvert: receiver explicitlyTo: compiler booleanType with: builder at: message.
	conditionResult := message type isBooleanType ifTrue: [ condition ] ifFalse: [ receiverType ssaConvert: receiver explicitlyTo: message type with: builder at: message].

	"Get the block type"
	blockType := block type withoutReferences.
	blockResultType := blockType.
	(blockType isFunctionType or: [ blockType isBlockType ]) ifTrue: [ 
		blockResultType := blockType returnType
	].

	startBlock := builder currentBlock.	
	mergeBlock := builder newBasicBlock: #orMerge.
	continueBlock := builder newBasicBlock: #orContinue.
	
	"Perform the branch"
	branch := builder branch: condition ifTrue: mergeBlock ifFalse: continueBlock.
	branch mergeBlock: mergeBlock.
	
	"Evaluate the inline block"
	builder currentBlock: continueBlock.
	continueResult := self inlineBlock: block arguments: #() types: #().
	blockResultType ~= message type ifTrue: [
		continueResult := blockResultType ssaConvert: continueResult explicitlyTo: message type with: builder at: message
	].
	
	builder jump: mergeBlock.

	"Continue"	
	builder currentBlock: mergeBlock.
	phi := builder phi: message type ssaType.
	phi
		addValue: conditionResult from: startBlock;
		addValue: continueResult from: continueBlock.
	
	^ phi