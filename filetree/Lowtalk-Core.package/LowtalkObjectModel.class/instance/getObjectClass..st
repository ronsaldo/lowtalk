class creation
getObjectClass: anObject
	<compileTime>
	(SpecialLiterals includes: anObject) ifTrue: [
		^ specialLiteralClasses at: anObject
	].

	^ (getObjectClassFunction lowtalkValueWithArguments: { anObject headerPointer } types: { headerType pointer } compiler: compiler at: nil) object