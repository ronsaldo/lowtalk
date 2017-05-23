object accessing
setObject: object slot: slot value: value
	<compileTime>
	self assert: object class == LowtalkObjectInstance.
	object slots at: slot put: value