errors
semanticError: message
	^ LTCSemanticError new
		messageText: message;
		node: self;
		signal