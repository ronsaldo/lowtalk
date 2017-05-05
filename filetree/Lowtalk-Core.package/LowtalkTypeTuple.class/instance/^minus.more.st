associating
-> returnType
	<compileTime>
	^ (LowtalkFunctionType target: compilationTarget)
		arguments: types;
		returnType: returnType;
		yourself