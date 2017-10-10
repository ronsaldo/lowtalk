building
anon
	<compileTime>
	| class |
	class := self typeClass target: compiler compilationTarget.
	class
		compiler: compiler.
	compiler addPendingObject: class.
	^ class