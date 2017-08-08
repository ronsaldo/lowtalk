as yet unclassified
evaluateNormalMessage: message receiver: receiver receiverType: receiverType inSuperclass: superClass
	| arguments argumentTypes |
 
	receiverType isCompileTimeType ifTrue: [
		receiver isNamespace ifTrue: [ 
			message selector precedence = 1 ifTrue: [
				^ self setCompileTimeValue: (receiver lookSymbol: message selector ifAbsent: [
					message semanticError: 'Namespace {1} does not have member named {2}' format: { receiver name . message selector }
				]) in: message.
			].
		].
	].

	(self compiler isLazySelector: message selector) ifTrue: [ 
		arguments := message arguments collect: [ :arg |
			LowtalkLazyValue new evaluator: self; node: arg
		].

		^ receiver lowtalkPerform: message selector withLazyArguments: arguments inSuperclass: superClass node: message compiler: compiler
	] ifFalse: [ 
		arguments := message arguments collect: [ :arg | self visitNode: arg].
		argumentTypes := message arguments collect: [ :arg | arg type withoutReferences ].

		message arguments doWithIndex: [ :arg :index |
			| argType |
			argType := argumentTypes at: index.
			arguments at: index put:  (arg type convertValue: (arguments at: index) toType: argType at: arg)
		].

		^ receiver lowtalkPerform: message selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: message compiler: compiler
	].
