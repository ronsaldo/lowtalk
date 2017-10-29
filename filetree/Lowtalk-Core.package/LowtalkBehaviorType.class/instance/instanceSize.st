formatting
instanceSize
	<compileTime>
	self nativeSlots ifNotEmpty: [ 
		self flag: 'TODO: Add support for mixed objects.'.
		self assert: self objectSlots isEmpty.
		^ self nativeContentSize
	].

	^ self objectSlots size