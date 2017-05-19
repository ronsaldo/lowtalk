accessing
resultTypeForMetaSelector: selector message: messageNode compiler: aCompiler
	(#(basicNew new) includes: selector) ifTrue: [ ^ self ].
	^ super resultTypeForMetaSelector: selector message: messageNode compiler: aCompiler