class creation
getObjectClass: anObject
	<compileTime>
	(SpecialLiterals includes: anObject) ifTrue: [
		^ specialLiteralClasses at: anObject
	].

	^ getObjectClassFunction lowtalkValueWithArguments: { anObject } types: { headerType pointer } compiler: compiler at: nil