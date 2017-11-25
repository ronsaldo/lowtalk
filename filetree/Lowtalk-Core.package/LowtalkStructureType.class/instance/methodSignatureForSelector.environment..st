methods
methodSignatureForSelector: selector environment: anEnvironment
	| result |
	result := self doGetMethodSignatureForSelector: selector environment: anEnvironment.
	result ifNotNil: [ ^ result ].
	^ nil