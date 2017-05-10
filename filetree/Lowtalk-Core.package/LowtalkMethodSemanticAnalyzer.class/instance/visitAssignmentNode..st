visiting
visitAssignmentNode: node
	| referenceType expectedType |
	node value accept: self.
	node reference accept: self.
	
	referenceType := node reference type.
	referenceType isReferenceType ifFalse: [
		node semanticError: 'Expected a reference to perform assignment instead of value of type {1}.' format: { referenceType name }
	].

	"Make sure the value can be converted to the expected type."
	expectedType := referenceType referenced.
	node value type implicitlyConvertedTo: expectedType at: node.

	"Set the result type."	
	node type: referenceType.
