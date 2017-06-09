messages
generateWhileLoopMessage: message
	| loopHeader loopBody loopMerge condition conditionBlockType conditionType branch |
	self assert: message type isNilType.
	
	loopHeader := builder newBasicBlock: #loopHeader.
	loopBody := builder newBasicBlock: #loopBody.
	loopMerge := builder newBasicBlock: #loopMerge.
	
	"Enter into the loop"
	builder jump: loopHeader.
	builder currentBlock: loopHeader.
	
	"Evaluate the condition"
	condition := self inlineBlock: message receiver arguments: #() types: #().
	builder isLastTerminator ifTrue: [ ^ nil ].
	
	conditionBlockType := message receiver type withoutReferences.
	conditionType := conditionBlockType functionType returnType.
	conditionType isReferenceType ifTrue: [ 
		condition := self coerceImplicitly: condition type: conditionType to: conditionType withoutReferences at: message.
		conditionType := conditionType withoutReferences
	].

	condition := self convertValue: condition type: conditionType toConditionOf: message selector at: message.

	branch := builder branch: condition ifTrue: loopBody ifFalse: loopMerge.
	branch
		continueBlock: loopHeader;
		mergeBlock: loopMerge.
		
	"Emit the loop body"
	builder currentBlock: loopBody.
	message arguments ifNotEmpty: [ 
		self inlineBlock: message arguments first arguments: #() types: #()
	].
	
	builder isLastTerminator ifFalse: [ 
		builder jump: loopHeader.
	].

	"End the loop"
	builder currentBlock: loopMerge.
	
	^ nil