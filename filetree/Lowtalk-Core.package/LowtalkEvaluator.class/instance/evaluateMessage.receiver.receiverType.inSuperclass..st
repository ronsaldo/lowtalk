visiting
evaluateMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass
	| arguments |
	message compileTimeValue ifNotNil: [ ^ message compileTimeValue ].
	
	receiverType isCompileTimeType ifTrue: [
		(receiver isNamespace and: [ message selector precedence = 1 ]) ifTrue: [
			^ self setCompileTimeValue: (receiver lookSymbol: message selector ifAbsent: [
				message semanticError: 'Namespace {1} does not have member named {2}' format: { receiver name . message selector }
			]) in: message
		].
	
		self halt.
	].

	arguments := message arguments collect: [ :arg |
		LowtalkLazyValue new evaluator: self; node: arg
	].

	^ receiver lowtalkPerform: message selector withArguments: arguments inSuperclass: superClass node: message