visiting
visitBlockNode: node
	node definition: (self class new analyzeBlock: node environment: environment parentMethod: method).
	
	self flag: 'TODO: Support full block closures for these cases.'.
	node definition receiverType isVoidType ifFalse: [ method markLazySelectorPresence ].
	node definition hasLocalReturns ifTrue: [ method markLazySelectorPresence ].
	^ node definition