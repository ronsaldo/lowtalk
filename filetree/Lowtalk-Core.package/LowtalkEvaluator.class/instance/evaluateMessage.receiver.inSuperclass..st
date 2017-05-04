visiting
evaluateMessage: message receiver: receiver inSuperclass: superClass
	| arguments |
	arguments := message arguments collect: [ :arg |
		LowtalkLazyValue new evaluator: self; node: arg
	].

	^ receiver lowtalkPerform: message selector withArguments: arguments inSuperclass: superClass node: message