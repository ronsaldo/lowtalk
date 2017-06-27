accessing
resultTypeForMetaSelector: selector message: messageNode compiler: compiler
	(#(size alignment) includes: selector) ifTrue: [ ^ compiler uintPointerType ].
	^ compiler objectType