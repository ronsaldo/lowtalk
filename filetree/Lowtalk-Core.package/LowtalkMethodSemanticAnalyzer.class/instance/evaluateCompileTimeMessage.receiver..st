visiting
evaluateCompileTimeMessage: message receiver: receiver
	|evaluator receiverValue superClass |
	evaluator := self asEvaluator.
	receiverValue := evaluator evaluate: receiver.
	receiverValue isNamespace ifTrue: [ 
		(receiverValue concreteMethodForSelector: message selector) ifNotNil: [ :concreteMethod |
			message compileTimeMessageLookup: concreteMethod.
			^ self checkMessage: message receiver: receiver
		]
	].
	superClass := receiver superClassForValue: receiverValue.
	evaluator evaluateMessage: message receiver: receiverValue receiverType: receiver type inSuperclass: superClass.
	
	self assert: message compileTimeValue isNotNil.