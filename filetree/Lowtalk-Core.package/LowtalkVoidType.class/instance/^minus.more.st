associating
-> returnType
	<compileTime>
	^ (LowtalkFunctionType target: compilationTarget)
		arguments: #();
		returnType: returnType;
		yourself