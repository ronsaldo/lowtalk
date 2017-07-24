messages
generateUncheckedFramePointerMessage: message
	self assert: message arguments isEmpty.
	^ builder getFramePointer