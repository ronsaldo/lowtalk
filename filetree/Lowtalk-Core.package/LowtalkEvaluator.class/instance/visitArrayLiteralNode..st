visiting
visitArrayLiteralNode: literal
	literal setTypeIfNil: self compiler objectType.
	^ literal value