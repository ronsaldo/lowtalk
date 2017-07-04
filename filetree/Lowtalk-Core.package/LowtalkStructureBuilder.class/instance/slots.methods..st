building
slots: slotsLazyValue methods: methods
	<compileTime>
	<lazy>
	| structure |
	
	structure := LowtalkStructureType target: compiler compilationTarget.
	structure
		compiler: compiler;
		slots: slotsLazyValue;
		methods: methods value.

	^ structure