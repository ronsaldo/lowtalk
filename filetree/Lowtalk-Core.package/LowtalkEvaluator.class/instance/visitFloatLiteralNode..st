visiting
visitFloatLiteralNode: literal
	literal setTypeIfNil: self compiler floatLiteralType.
	^ literal value