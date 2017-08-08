visiting
visitMessageNode: message
	(message receiver isBlockNode and: [ BlockMessages includesKey: message selector ]) ifFalse: [ 
		self visitNode: message receiver.
	].
	
	^ self checkMessage: message receiver: message receiver.