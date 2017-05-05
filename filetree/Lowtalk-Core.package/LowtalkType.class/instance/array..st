type composition
array: elements
	<compileTime>
	^ (LowtalkArrayType target: compilationTarget) baseType: self; elements: elements; yourself