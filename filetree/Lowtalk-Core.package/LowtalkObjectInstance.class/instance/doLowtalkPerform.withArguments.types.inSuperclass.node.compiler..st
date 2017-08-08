message dispatching
doLowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	| method |
	(self isRegisteredClass and: [ClassPrimitiveSelectors includesKey: selector]) ifTrue: [
		^ self perform: (ClassPrimitiveSelectors at: selector) withArguments: arguments
	].
	ObjectPrimitiveSelectors at: selector ifPresent: [ :implementation |
		(#(castTo: reinterpretCastTo:) includes: selector) ifTrue: [
			^ self perform: implementation withArguments: (LowtalkLazyValue zipValues: arguments types: argumentTypes node: aCompiler)
		].

		^ self perform: implementation withArguments: arguments
	].

	method := compiler objectModel lookupSelectorFunction value: self behavior value: selector.
	method ifNil: [
		self flag: 'TODO: Send doesNotUnderstand:'.
		sendingNode semanticError: 'Unsupported selector {1} ' format: { selector printString }
	].

	^ method lowtalkValueWithArguments: { self } , arguments
		types: {self type} , argumentTypes compiler: aCompiler at: sendingNode