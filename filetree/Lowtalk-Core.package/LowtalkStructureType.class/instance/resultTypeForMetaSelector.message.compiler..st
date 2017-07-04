accessing
resultTypeForMetaSelector: selector message: messageNode compiler: aCompiler
	(#(basicNew new) includes: selector) ifTrue: [ ^ self ].
	(#(basicNewPointer newPointer) includes: selector) ifTrue: [ ^ self pointer ].
	^ super resultTypeForMetaSelector: selector message: messageNode compiler: aCompiler