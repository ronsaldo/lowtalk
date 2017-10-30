methods
methodSignatureForSelector: selector environment: environment
	^ environment receiverType ifNotNil: [ :receiver |
		receiver metaClass ifNotNil: [ :meta | meta methodSignatureForSelector: selector environment: environment ]
	]