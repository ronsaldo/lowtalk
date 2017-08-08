inline messages
generateOrMessage: message receiverType: receiverType inSuperclass: inSuperclass
	self convertExplicitlyFrom: receiverType to: compiler booleanType at: message.
	irBuilder jumpAheadTo: #else if: false.
	irBuilder pushLiteral: true. 
	irBuilder jumpAheadTo: #end.
	
	irBuilder jumpAheadTarget: #else.
	self inlineBlock: message arguments first.
	irBuilder jumpAheadTarget: #end.
