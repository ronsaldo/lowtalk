messages
generateIfSelectionMessage: message receiver: receiver receiverType: receiverType
	| value condition valueType trueBlock mergeBlock falseBlock branch trueResult falseResult coercionType selectionBlock result jumpFromTrue jumpFromFalse |
	coercionType := message type.
	
	value := receiver.
	valueType := receiverType withoutReferences.
	value := self coerceImplicitly: value type: message receiver type to: valueType at: message.
	
	falseResult := nil.
	(message arguments size = 1 and: [coercionType isNilType not]) ifTrue: [ 
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
	jumpFromFalse := false.
	falseBlock := message arguments size = 2 ifTrue: [ builder newBasicBlock: #ifConditionFalse ] ifFalse: [
			jumpFromFalse := true.
			mergeBlock
	].
	
	"Perform the branch"
	branch := builder branch: condition ifTrue: trueBlock ifFalse: falseBlock.
	branch mergeBlock: mergeBlock.
	selectionBlock := builder currentBlock.
	
	"Generate the true block."
	builder currentBlock: trueBlock.
	(#(#ifNotNil: #ifNotNil:ifNil:) includes: message selector) ifTrue: [ 
		trueResult := self inlineBlock: message arguments first cull: {value} types: {valueType}
	] ifFalse: [ 
		trueResult := self inlineBlock: message arguments first arguments: #() types: #()
	].

	jumpFromTrue := false.
	builder isLastTerminator ifTrue: [ 
		trueResult := nil.
		trueBlock := nil.
	] ifFalse: [ 
		coercionType isVoidType ifFalse: [
			trueResult := self coerceImplicitly: trueResult type: (self inlinedBlockReturnType: message arguments first) to: coercionType at: message.
		].

		trueBlock := builder currentBlock.
		builder jump: mergeBlock.
		jumpFromTrue := true.
	].

	"Generate the false block"
	message arguments size = 2 ifTrue: [ 
		builder currentBlock: falseBlock.
		(#ifNil:ifNotNil: = message selector) ifTrue: [ 
			falseResult := self inlineBlock: message arguments second cull: {value} types: {valueType}
		] ifFalse: [ 
			falseResult := self inlineBlock: message arguments second arguments: #() types: #()
		].
	
		coercionType isVoidType ifFalse: [
			falseResult := self coerceImplicitly: falseResult type: (self inlinedBlockReturnType: message arguments second) to: coercionType at: message.
		].

		falseBlock := builder currentBlock.
		builder isLastTerminator ifFalse: [
			builder jump: mergeBlock.
			jumpFromFalse := true.
		].
	].
	
	mergeBlock predecessors ifEmpty: [
		builder currentBlock: mergeBlock.
		builder unreachable.
		^ branch addUnreachableSuccessors.
	] ifNotEmpty: [
		mergeBlock predecessors size = 1 ifTrue: [
			jumpFromTrue ifTrue: [
				branch mergeBlock: trueBlock.
			] ifFalse: [
				self assert: jumpFromFalse.
				branch mergeBlock: falseBlock.
			]
		].
	
		builder currentBlock: mergeBlock.
	].

	"Special values"
	(coercionType isNilType or: [ coercionType isVoidType ]) ifTrue: [ ^ nil ].
	
	"Merge the result"	
	trueResult ifNotNil: [ 
		result := builder phi: coercionType ssaType name: #ifResult.
		trueResult type isVoidType ifFalse: [ result addValue: trueResult from: trueBlock ].
		message arguments = 1 ifTrue: [
			falseResult type isVoidType ifFalse: [ result addValue: falseResult from: selectionBlock ]
		] ifFalse: [
			falseResult type isVoidType ifFalse: [ result addValue: falseResult from: falseBlock ]
		].
		^ result
	] ifNil: [
		^ falseResult
	]
