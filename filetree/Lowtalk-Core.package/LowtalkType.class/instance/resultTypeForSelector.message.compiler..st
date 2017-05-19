accessing
resultTypeForSelector: selector message: messageNode compiler: compiler
	(#(yourself) includes: selector) ifTrue: [ self ].
	
	self flag: 'Try to deduce a better result type'.
	^ compiler objectType