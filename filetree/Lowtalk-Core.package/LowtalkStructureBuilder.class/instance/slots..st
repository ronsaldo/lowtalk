building
slots: slotsLazyValue
	<compileTime>
	<lazy>
	| structure |
	
	structure := LowtalkStructureType target: compiler compilationTarget.
	structure
		compiler: compiler;
		slots: slotsLazyValue.
	
	^ structure