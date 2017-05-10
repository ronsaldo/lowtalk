visiting
visitMessageNode: message
	message compileTimeValue ifNotNil: [ ^ message compileTimeValue ssaValue ].
	message specialMessageType ifNotNil: [ ^ self generateSpecialMessage: message ].
	^ self generateNormalMessage: message