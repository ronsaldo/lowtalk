visiting
visitAssignmentNode: aNode
	self flag: 'TODO: Support per value identifiers.'.
	self assert: aNode reference type isReferenceType.
	
	self visitNode: aNode reference.
	self visitNode: aNode value.
	self coerceImplicitlyFrom: aNode value type to: aNode reference type withoutReferences at:  aNode.
	irBuilder send: #value:.
