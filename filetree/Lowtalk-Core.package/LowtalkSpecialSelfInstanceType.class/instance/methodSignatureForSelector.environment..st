methods
methodSignatureForSelector: selector environment: environment
	^ environment receiverType ifNotNil: [ :receiver |
		receiver instanceOrNil ifNotNil: [ :instance | instance methodSignatureForSelector: selector environment: environment ]
	]