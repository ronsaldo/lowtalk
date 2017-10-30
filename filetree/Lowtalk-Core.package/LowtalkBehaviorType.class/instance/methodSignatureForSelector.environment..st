methods
methodSignatureForSelector: selector environment: anEnvironment
	| result |
	result := methodSignatureDictionary at: selector ifAbsent: [
		pendingMethods at: selector ifPresent: [ :method |
			methodSignatureDictionary at: selector put: (method methodSignatureForReceiverTypeValue: self)
		] ifAbsent: [nil].
	].
	result ifNotNil: [ ^ result ].
	^ self superclass ifNotNil: [ :sc | sc methodSignatureForSelector: selector environment: anEnvironment]