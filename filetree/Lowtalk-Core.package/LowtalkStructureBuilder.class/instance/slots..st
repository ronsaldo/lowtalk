building
slots: slotsLazyValue
	<compileTime>
	<lazy>
	| structure |
	
	structure := self typeClass target: compiler compilationTarget.
	structure
		compiler: compiler;
		slots: slotsLazyValue.
	
	^ structure