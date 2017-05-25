associating
-> returnType
	<compileTime>
	^ (LowtalkFunctionType target: self compilationTarget)
		arguments: { self };
		returnType: returnType;
		yourself