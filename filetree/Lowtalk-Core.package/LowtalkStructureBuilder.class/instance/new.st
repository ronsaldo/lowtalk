building
new
	<compileTime>
	| structure |
	structure := LowtalkStructureType target: compiler compilationTarget.
	structure
		compiler: compiler.

	^ structure