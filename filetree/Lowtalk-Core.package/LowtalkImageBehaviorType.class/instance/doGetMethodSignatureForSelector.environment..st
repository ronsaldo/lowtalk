methods
doGetMethodSignatureForSelector: selector environment: anEnvironment
	| result |
	result := super doGetMethodSignatureForSelector: selector environment: anEnvironment.
	(result isNil and: [ classObject isNotNil ]) ifTrue: [
		classObject methodDict at: selector ifPresent: [ :compiledMethod |
			^ self importMethodSignatureFrom: compiledMethod environment: anEnvironment
		]
	].
	^ result