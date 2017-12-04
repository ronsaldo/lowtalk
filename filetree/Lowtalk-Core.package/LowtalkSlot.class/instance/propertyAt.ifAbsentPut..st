properties
propertyAt: propertyName ifAbsentPut: aBlock
	<compileTime>
	properties ifNil: [ properties := Dictionary new ].
	^ properties at: propertyName ifAbsentPut: aBlock