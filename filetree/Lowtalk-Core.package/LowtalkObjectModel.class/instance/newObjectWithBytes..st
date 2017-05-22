object creation
newObjectWithBytes: slotCount
	<compileTime>
	| header |
	header := newObjectHeaderWithBytes value: slotCount.
	^ LowtalkObjectInstance new
		compiler: compiler;
		header: header;
		slots: (ByteArray new: slotCount);
		yourself
	