methods
doGetMethodSignatureForSelector: selector environment: anEnvironment
	^ methodSignatureDictionary at: selector ifAbsent: [
		pendingMethods at: selector ifPresent: [ :method |
			methodSignatureDictionary at: selector put: (method methodSignatureForReceiverTypeValue: self ref)
		] ifAbsent: [nil].
	].