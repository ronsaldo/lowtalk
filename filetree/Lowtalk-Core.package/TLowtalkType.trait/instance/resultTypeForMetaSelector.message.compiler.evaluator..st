accessing
resultTypeForMetaSelector: selector message: messageNode compiler: compiler evaluator: evaluator
	(#(size alignment) includes: selector) ifTrue: [ ^ compiler uintPointerType ].
	^ compiler objectType