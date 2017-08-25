building
slots: slotsLazyValue methods: methods
	<compileTime>
	<lazy>
	| structure |
	
	structure := self typeClass target: compiler compilationTarget.
	structure
		compiler: compiler;
		slots: slotsLazyValue;
		methods: methods value.

	^ structure