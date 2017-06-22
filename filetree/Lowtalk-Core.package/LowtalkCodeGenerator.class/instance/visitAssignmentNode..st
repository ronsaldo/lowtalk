visiting
visitAssignmentNode: assignmentNode
	| value valueType reference referenceType expectedType convertedValue |
	value := self visitNode: assignmentNode value.
	valueType := assignmentNode value type.
	
	reference := self visitNode: assignmentNode reference.
	referenceType := assignmentNode reference type.
	
	expectedType := referenceType withoutReferences.
	convertedValue := self coerceImplicitly: value type: valueType to: expectedType at:  assignmentNode.
	
	builder store: convertedValue in: reference.

	^ reference
	