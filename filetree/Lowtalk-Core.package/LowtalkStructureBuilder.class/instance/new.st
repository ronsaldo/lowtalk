building
new
	<compileTime>
	| structure |
	structure := self typeClass target: compiler compilationTarget.
	structure
		compiler: compiler.

	^ structure