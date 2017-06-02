class primitives
classPrimitive_basicNew: size
	"TODO: Retrieve the fixed instance size and the format."
	| result description |
	description := self getClassDescription.
	result := compiler objectModel perform: (NewObjectForType at: description type) with: description instanceSize + size.
	compiler objectModel setObject: result class: self.
	^ result