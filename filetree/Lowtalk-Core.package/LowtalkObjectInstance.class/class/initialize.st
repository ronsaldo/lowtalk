initialization
initialize
	ClassPrimitiveSelectors := Set newFrom: #(basicNew basicNew:).
	ObjectPrimitiveSelectors := Set newFrom: #(
		basicAt: basicAt:put: basicSize
		identityHash class
		== ~~
		castTo: reinterpretCastTo:
		).
	NewObjectForType := Dictionary newFromPairs: #(
		pointers newObjectWithPointers:
		variablePointers newObjectWithPointers:
		bytes newObjectWithBytes:
	)
	