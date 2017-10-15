class primitives
classPrimitive_basicNew: size
	"TODO: Retrieve the fixed instance size and the format."
	| result resultSize |
	resultSize := self instanceSize + size.
	result := self createRawObjectOfLayoutType: self layoutType size: resultSize.
	compiler objectModel setObject: result class: self classObject.
	^ result