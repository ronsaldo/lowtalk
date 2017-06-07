visiting
checkOrMessage: message receiver: receiver
	| argument |
	self assert: message arguments size = 1.
	argument := message arguments first.
	self visitInlinedBlock: argument types: #() from: message.
	
	message setTypeIfNil: compiler booleanType.