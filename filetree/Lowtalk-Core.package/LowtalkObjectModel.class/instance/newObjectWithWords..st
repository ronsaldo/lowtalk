object creation
newObjectWithWords: slotCount
	<compileTime>
	| header |
	header := newObjectHeaderWithWords value: slotCount.
	^ LowtalkObjectInstance new
		compiler: compiler;
		header: header;
		slots: (WordArray new: slotCount);
		yourself
	