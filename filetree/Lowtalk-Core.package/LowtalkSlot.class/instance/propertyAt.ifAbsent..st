properties
propertyAt: propertyName ifAbsent: aBlock
	<compileTime>
	properties ifNil: [ ^ aBlock value ].
	^ properties at: propertyName ifAbsent: aBlock