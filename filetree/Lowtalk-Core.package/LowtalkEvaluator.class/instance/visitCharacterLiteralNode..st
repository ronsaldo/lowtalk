visiting
visitCharacterLiteralNode: literal
	literal setTypeIfNil: self compiler characterLiteralType.
	^ literal value