initialization
initialize
	NewObjectForType := Dictionary newFromPairs: #(
		pointers newObjectWithPointers:
		variablePointers newObjectWithPointers:
		bytes newObjectWithBytes:
	).
	