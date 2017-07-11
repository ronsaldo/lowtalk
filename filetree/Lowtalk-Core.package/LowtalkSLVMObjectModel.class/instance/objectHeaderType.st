trampoline names
objectHeaderType
	^ compiler objectModel headerType ifNotNil: [:headerType | headerType ssaType]