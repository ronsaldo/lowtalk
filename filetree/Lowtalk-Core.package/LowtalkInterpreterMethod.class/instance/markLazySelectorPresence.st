as yet unclassified
markLazySelectorPresence
	hasLazySelector ifTrue: [ ^ true ].
	
	hasLazySelector := true.
	(parentMethod isNotNil and: [hasLocalReturns not]) ifTrue: [
		parentMethod markLazySelectorPresence
	]