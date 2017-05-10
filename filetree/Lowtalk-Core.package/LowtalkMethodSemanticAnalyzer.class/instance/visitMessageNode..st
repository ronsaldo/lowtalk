visiting
visitMessageNode: message
	(message receiver isBlockNode and: [ BlockMessages includes: message selector ]) ifFalse: [ 
		message receiver accept: self.
	].
	
	^ self checkMessage: message receiver: message receiver.