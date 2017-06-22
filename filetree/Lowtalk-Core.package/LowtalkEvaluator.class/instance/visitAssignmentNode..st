visiting
visitAssignmentNode: node
	| value reference referenceType expectedType |
	value := self visitNode: node value.
	reference := self visitNode: node reference.
	
	referenceType := node reference type.
	referenceType isReferenceType ifFalse: [
		node semanticError: 'Expected a reference to perform assignment instead of value of type {1}.' format: { referenceType name }
	].

	"Make sure the value can be converted to the expected type."
	expectedType := referenceType referenced.
	node value type implicitlyConvertedTo: expectedType at: node.
	value := node value type convertValue: value toType: expectedType at: node.

	"Set the value"
	reference value: value.
	
	"Set the result type."	
	node setTypeIfNil: referenceType.
	^ reference