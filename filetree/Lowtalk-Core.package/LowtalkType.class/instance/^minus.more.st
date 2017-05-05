associating
-> returnType
	<compileTime>
	^ (LowtalkFunctionType target: compilationTarget)
		arguments: { self };
		returnType: returnType;
		yourself