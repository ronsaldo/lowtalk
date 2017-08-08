visiting
visitBlockNode: node
	node definition: (self class new analyzeBlock: node environment: environment parentMethod: method).
	
	self flag: 'TODO: Support full block closures'.
	node definition hasLocalReturns ifTrue: [ method markLazySelectorPresence ].
	^ node definition