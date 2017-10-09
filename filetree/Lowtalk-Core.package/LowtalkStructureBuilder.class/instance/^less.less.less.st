building
<<< nameLazyValue
	<compileTime>
	<lazy>
	| structure |
	structure := self anon. 
	compiler globalBuilder named: nameLazyValue type: structure metaType value: structure.
	structure name: nameLazyValue value.
	^ structure