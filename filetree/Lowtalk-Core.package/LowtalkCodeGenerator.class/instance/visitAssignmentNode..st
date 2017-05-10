visiting
visitAssignmentNode: assignmentNode
	| value valueType reference referenceType expectedType convertedValue |
	value := assignmentNode value accept: self.
	valueType := assignmentNode value type.
	
	reference := assignmentNode reference accept: self.
	referenceType := assignmentNode reference type.
	
	expectedType := referenceType withoutReferences.
	convertedValue := self coerceImplicitly: value type: valueType to: expectedType at:  assignmentNode.
	
	builder store: convertedValue in: reference.

	^ reference
	