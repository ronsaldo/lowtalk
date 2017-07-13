accessing
resultTypeForSelector: selector message: messageNode compiler: compiler evaluator: evaluator
	(#(yourself) includes: selector) ifTrue: [ self ].
	(#(castTo: reinterpretCastTo:) includes: selector) ifTrue: [ ^ evaluator solveTypeExpression: messageNode arguments first ].
	self flag: 'Try to deduce a better result type'.
	^ compiler objectType