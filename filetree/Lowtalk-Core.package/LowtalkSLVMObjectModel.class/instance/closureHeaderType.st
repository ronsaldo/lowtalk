trampoline names
closureHeaderType
	^ compiler objectModel closureHeaderType ifNotNil: [:closureHeaderType | closureHeaderType ssaType]