visiting
visitNilLiteralNode: aNode
	aNode setTypeIfNil: compiler nilType.
	^ nil