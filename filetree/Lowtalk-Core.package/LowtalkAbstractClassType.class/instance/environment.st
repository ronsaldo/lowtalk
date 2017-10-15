accessing
environment
	<compileTime>
	environment ifNil: [ self halt ].
	^ environment