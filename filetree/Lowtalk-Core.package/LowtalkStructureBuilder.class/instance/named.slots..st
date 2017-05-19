building
named: nameLazyValue slots: slotsLazyValue
	<compileTime>
	<lazy>
	| structure |
	structure := self slots: slotsLazyValue. 
	compiler globalBuilder named: nameLazyValue type: structure metaType value: structure.
	structure name: nameLazyValue value.
	^ structure