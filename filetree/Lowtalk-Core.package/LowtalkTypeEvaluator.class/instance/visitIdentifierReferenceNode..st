visiting
visitIdentifierReferenceNode: identifier
	^ (super visitIdentifierReferenceNode: identifier) value asLowtalkTypeIn: identifier