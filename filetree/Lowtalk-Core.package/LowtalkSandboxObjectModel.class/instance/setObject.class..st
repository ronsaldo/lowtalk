class creation
setObject: anObject class: class
	<compileTime>
	(SpecialLiterals includes: anObject) ifTrue: [
		^ specialLiteralClasses at: anObject put: class
	].

	setObjectClassFunction lowtalkValueWithArguments: { anObject headerPointer. class headerPointer } types: { headerType pointer . headerType pointer } compiler: compiler at: nil.
	^ anObject