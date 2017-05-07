visiting
visitMessageNode: message
	message receiver accept: self.
	^ self checkMessage: message receiver: message receiver.