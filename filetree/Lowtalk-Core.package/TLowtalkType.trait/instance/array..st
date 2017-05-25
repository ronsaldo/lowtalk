type composition
array: elementCount
	<compileTime>
	^ (LowtalkArrayType target: self compilationTarget)
		baseType: self;
		elements: elementCount;
		yourself