building
named: nameLazyValue slots: slotsLazyValue
	<compileTime>
	<lazy>
	| structure |
	structure := self slots: slotsLazyValue. 
	compiler globalBuilder named: nameLazyValue type: compiler objectType value: structure.
	structure name: nameLazyValue value.
	^ structure