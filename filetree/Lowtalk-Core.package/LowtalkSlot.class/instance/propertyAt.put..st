properties
propertyAt: propertyName put: propertyValue
	<compileTime>
	properties ifNil: [ properties := Dictionary new ].
	^ properties at: propertyName put: propertyValue