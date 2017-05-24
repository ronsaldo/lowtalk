object accessing
getObjectClass: anObject
	<compileTime>
	^ getObjectClassFunction lowtalkValueWithArguments: { anObject } types: { headerType pointer } compiler: compiler at: nil