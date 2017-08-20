testing
isReferenceCounted
	^ self increaseReference isNotNil and: [ self releaseReference isNotNil ]