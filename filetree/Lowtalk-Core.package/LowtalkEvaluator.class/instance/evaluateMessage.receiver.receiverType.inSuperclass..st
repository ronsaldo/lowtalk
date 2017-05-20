visiting
evaluateMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass
	message compileTimeValue ifNotNil: [ ^ message compileTimeValue ].
	InlineMessages at: message selector ifPresent: [ :inlineSelector |
		^ self perform: inlineSelector withArguments: { message . receiver . receiverType . superClass }
	].
 	^ self evaluateNormalMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass
