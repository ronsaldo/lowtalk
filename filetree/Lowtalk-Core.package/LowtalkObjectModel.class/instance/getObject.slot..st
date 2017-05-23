object accessing
getObject: object slot: slot
	<compileTime>
	self assert: object class == LowtalkObjectInstance.
	^ object slots at: slot