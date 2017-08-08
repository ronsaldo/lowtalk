evaluating
valueWithArguments: evaluationArguments
	<compileTime>
	^ self lowtalkValueWithArguments: evaluationArguments types: (evaluationArguments collect: [:arg | arg lowtalkLiteralTypeWith: definition compiler]) compiler: definition compiler at: LowtalkASTNode new.