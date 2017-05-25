visiting
visitIntegerLiteralNode: literal
	literal setTypeIfNil: self compiler integerLiteralType.
	^ literal value