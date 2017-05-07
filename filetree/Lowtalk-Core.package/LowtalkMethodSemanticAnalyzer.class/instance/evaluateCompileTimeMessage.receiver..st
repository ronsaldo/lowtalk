visiting
evaluateCompileTimeMessage: message receiver: receiver
	|evaluator receiverValue superClass |
	evaluator := self asEvaluator.
	receiverValue := evaluator evaluate: receiver.
	superClass := receiver superClassForValue: receiverValue.
	evaluator evaluateMessage: message receiver: receiverValue receiverType: receiver type inSuperclass: superClass.
	
	self assert: message compileTimeValue isNotNil.