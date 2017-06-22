visiting
visitMessageNode: message
	(message receiver isBlockNode and: [ BlockMessages includes: message selector ]) ifFalse: [ 
		self visitNode: message receiver.
	].
	
	^ self checkMessage: message receiver: message receiver.