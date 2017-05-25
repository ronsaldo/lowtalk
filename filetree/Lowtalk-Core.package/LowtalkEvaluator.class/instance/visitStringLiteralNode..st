visiting
visitStringLiteralNode: literal
	literal setTypeIfNil: self compiler stringLiteralType.
	^ literal value