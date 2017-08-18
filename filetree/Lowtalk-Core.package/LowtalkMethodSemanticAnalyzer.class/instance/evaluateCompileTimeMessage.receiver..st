visiting
evaluateCompileTimeMessage: message receiver: receiver
	|evaluator receiverValue superClass |
	evaluator := self asEvaluator.
	receiverValue := evaluator evaluate: receiver.
	receiverValue isNamespace ifTrue: [ 
		(receiverValue concreteMethodForSelector: message selector) ifNotNil: [ :concreteMethod |
			message compileTimeMessageLookup: concreteMethod.
			^ self checkMessage: message receiver: receiver
		].
	
		message selector precedence = 1 ifTrue: [
			^ self setCompileTimeValue: (receiverValue lookSymbol: message selector ifAbsent: [
					message semanticError: 'Namespace {1} does not have member named {2}' format: { receiverValue name . message selector }
			]) in: message.
		].
	
		^ self checkNormalMessage: message receiver: receiver
	].
	superClass := receiver superClassForValue: receiverValue.
	evaluator evaluateMessage: message receiver: receiverValue receiverType: receiver type inSuperclass: superClass.
	
	self assert: message compileTimeValue isNotNil.