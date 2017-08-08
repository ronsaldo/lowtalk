visiting
generateNormalMessage: message receiverType: receiverType inSuperclass: inSuperclass
	self coerceImplicitlyFrom: receiverType to: compiler objectType at: message.

	irBuilder pushLiteral: message selector.
	
	message arguments do: [ :arg |
		self visitNode: arg.
		self coerceImplicitlyFrom: arg type to: compiler objectType at: message.
	].

	irBuilder
		pushConsArray: message arguments size;
		pushLiteral: (message arguments collect: [:arg | compiler objectType]);
		pushLiteral: inSuperclass;
		pushLiteral: message;
		pushLiteral: compiler.

	irBuilder send: #lowtalkPerform:withArguments:types:inSuperclass:node:compiler: 
