methods
methodSignatureForSelector: selector environment: environment
	^ environment receiverType ifNotNil: [ :receiver | receiver methodSignatureForSelector: selector environment: environment]