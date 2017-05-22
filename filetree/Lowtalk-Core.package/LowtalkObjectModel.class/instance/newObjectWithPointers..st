object creation
newObjectWithPointers: slotCount
	<compileTime>
	| header |
	header := newObjectHeaderWithPointers value: slotCount.
	^ LowtalkObjectInstance new
		compiler: compiler;
		header: header;
		slots: (Array new: slotCount);
		yourself
	