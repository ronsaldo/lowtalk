visiting
visitSymbolLiteralNode: literal
	literal setTypeIfNil: self compiler symbolLiteralType.
	^ literal value