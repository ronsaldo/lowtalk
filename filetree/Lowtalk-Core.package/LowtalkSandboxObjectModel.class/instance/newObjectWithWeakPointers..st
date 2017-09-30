object creation
newObjectWithWeakPointers: slotCount
	<compileTime>
	| header |
	header := newObjectHeaderWithWeakPointers value: slotCount.
	^ LowtalkObjectInstance new
		compiler: compiler;
		header: header;
		slots: (WeakArray new: slotCount);
		yourself
	