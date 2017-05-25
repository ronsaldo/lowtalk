class primitives
classPrimitive_basicNew: size
	"TODO: Retrieve the fixed instance size and the format."
	| result |
	result := compiler objectModel newObjectWithPointers: size.
	compiler objectModel setObject: result class: self.
	^ result