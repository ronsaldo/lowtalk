properties
propertyAt: propertyName
	<compileTime>
	properties ifNil: [ self error: 'Property is not present.' ].
	^ properties at: propertyName