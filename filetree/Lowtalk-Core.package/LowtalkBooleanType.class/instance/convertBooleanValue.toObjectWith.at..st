coercions
convertBooleanValue: value toObjectWith: builder at: node
	| trueBlock falseBlock mergeBlock branch phi |
	trueBlock := builder newBasicBlock: #boolTrueCase.
	falseBlock := builder newBasicBlock: #boolFalseCase.
	mergeBlock := builder newBasicBlock: #boolMergeCase.
		
	branch := builder branch: value ifTrue: trueBlock ifFalse: falseBlock.
	branch mergeBlock: mergeBlock.
		
	builder
		currentBlock: trueBlock;
		jump: mergeBlock;
		currentBlock: falseBlock;
		jump: mergeBlock;
		currentBlock: mergeBlock.
	phi := builder phi: builder dynamicObjectType.
	phi addValue: (builder addDynamicLiteral: true) from: trueBlock.
	phi addValue: (builder addDynamicLiteral: false) from: falseBlock.
	^ phi