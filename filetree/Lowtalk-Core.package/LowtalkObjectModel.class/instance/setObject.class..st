object accessing
setObject: anObject class: class
	<compileTime>
	^ setObjectClassFunction lowtalkValueWithArguments: { anObject . class } types: { headerType pointer . headerType pointer } compiler: compiler at: nil