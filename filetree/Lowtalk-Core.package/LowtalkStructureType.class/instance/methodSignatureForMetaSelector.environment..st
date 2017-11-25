methods
methodSignatureForMetaSelector: selector environment: anEnvironment
	^ self metaClass ifNotNil: [ :meta | meta methodSignatureForSelector: selector environment: anEnvironment ]