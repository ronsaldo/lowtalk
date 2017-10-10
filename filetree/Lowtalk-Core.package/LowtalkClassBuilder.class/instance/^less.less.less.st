building
<<< nameLazyValue
	<compileTime>
	<lazy>
	| class |
	class := self anon. 
	compiler globalBuilder named: nameLazyValue type: class metaType value: class.
	class name: nameLazyValue value.
	^ class