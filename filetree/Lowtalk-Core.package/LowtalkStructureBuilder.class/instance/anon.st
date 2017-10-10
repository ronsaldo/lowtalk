building
anon
	<compileTime>
	| structure |
	structure := self typeClass target: compiler compilationTarget.
	structure
		compiler: compiler.
	compiler addPendingObject: structure.
	^ structure