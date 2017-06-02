messages
generateIfSelectionMessage: message receiver: receiver receiverType: receiverType
	| value condition valueType trueBlock mergeBlock falseBlock branch trueResult falseResult coercionType selectionBlock result |
	coercionType := message type.
	
	value := receiver.
	valueType := receiverType withoutReferences.
	value := self coerceImplicitly: value type: message receiver type to: valueType at: message.
	
	message arguments size = 1 ifTrue: [ 
		message selector = #ifNil: ifTrue: [
			falseResult := self coerceImplicitly: value type: valueType to: coercionType at: message.
		] ifFalse: [
			falseResult := self coerceImplicitly: nil type: compiler nilType to: coercionType at: message
		]
	].
	condition := self convertValue: value type: valueType toConditionOf: message selector at: message.

	"Create the basic blocks that are required"
	trueBlock := builder newBasicBlock: #ifConditionTrue.
	mergeBlock := builder newBasicBlock: #ifMerge.
	falseBlock := message arguments size = 2 ifTrue: [ builder newBasicBlock: #ifConditionFalse ] ifFalse: [ mergeBlock ].
	
	"Perform the branch"
	branch := builder branch: condition ifTrue: trueBlock ifFalse: falseBlock.
	branch mergeBlock: mergeBlock.
	selectionBlock := builder currentBlock.
	
	"Generate the true block."
	builder currentBlock: trueBlock.
	(#(#ifNotNil: #ifNotNil:ifNil:) includes: message selector) ifTrue: [ 
		trueResult := self inlineBlock: message arguments first cull: value types: valueType
	] ifFalse: [ 
		trueResult := self inlineBlock: message arguments first arguments: #() types: #()
	].

	coercionType isVoidType ifFalse: [
		trueResult := self coerceImplicitly: trueResult type: (self inlinedBlockReturnType: message arguments first) to: coercionType at: message.
	].

	trueBlock := builder currentBlock.
	builder isLastTerminator ifFalse: [ builder jump: mergeBlock ].
	
	"Generate the false block"
	message arguments size = 2 ifTrue: [ 
		builder currentBlock: falseBlock.
		(#ifNil:ifNotNil: = message selector) ifTrue: [ 
			falseResult := self inlineBlock: message arguments first cull: value types: valueType
		] ifFalse: [ 
			falseResult := self inlineBlock: message arguments first arguments: #() types: #()
		].
	
		coercionType isVoidType ifFalse: [
			falseResult := self coerceImplicitly: trueResult type: (self inlinedBlockReturnType: message arguments second) to: coercionType at: message.
		].

		falseBlock := builder currentBlock.
		builder isLastTerminator ifFalse: [ builder jump: mergeBlock ].
	].
	
	mergeBlock predecessors ifEmpty: [
		^ branch addUnreachableSuccessors.
	] ifNotEmpty: [ 
		builder currentBlock: mergeBlock.
	].

	"Special values"
	(coercionType isNilType or: [ coercionType isVoidType ]) ifTrue: [ ^ nil ].
	
	"Merge the result"	
	result := builder phi: coercionType ssaType name: #ifResult.
	result addValue: trueResult from: trueBlock.
	message arguments = 1 ifTrue: [
		result addValue: falseResult from: selectionBlock.
	] ifFalse: [ 
		result addValue: falseResult from: falseBlock.
	].

	^ result