inline messages
generateAndMessage: message receiverType: receiverType inSuperclass: inSuperclass
	self convertExplicitlyFrom: receiverType to: compiler booleanType at: message.
	irBuilder jumpAheadTo: #else if: true.
	irBuilder pushLiteral: false. 
	irBuilder jumpAheadTo: #end.
	
	irBuilder jumpAheadTarget: #else.
	self inlineBlock: message arguments first.
	irBuilder jumpAheadTarget: #end.
