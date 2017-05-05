accessing
compiler
	^ compiler ifNil: [compiler := environment compiler]