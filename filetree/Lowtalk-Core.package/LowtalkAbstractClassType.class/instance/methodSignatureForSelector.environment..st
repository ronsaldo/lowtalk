methods
methodSignatureForSelector: selector environment: anEnvironment
	| result |
	result := self doGetMethodSignatureForSelector: selector environment: anEnvironment.
	result ifNotNil: [ ^ result ].
	^ self superclass ifNotNil: [ :sc | sc methodSignatureForSelector: selector environment: anEnvironment]