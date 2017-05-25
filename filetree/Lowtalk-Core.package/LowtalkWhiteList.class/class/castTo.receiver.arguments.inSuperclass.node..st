overrides
castTo: selector receiver: receiver arguments: arguments inSuperclass: isInSuperclass node: aNode
	| targetType receiverType |
	self assert: arguments size = 1.
	targetType := arguments first value asLowtalkTypeIn: aNode.
	receiverType := receiver lowtalkLiteralTypeWith: arguments first compiler.
	^ receiverType convertValue: receiver toType: targetType at: aNode