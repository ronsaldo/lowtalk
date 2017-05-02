errors
environment: anEnvironment semanticError: message
	^ LTCSemanticError new
		messageText: message;
		node: self;
		environment: anEnvironment;
		signal