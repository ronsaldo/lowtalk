message dispatching
doLowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	| method |
	(self isRegisteredClass and: [ClassPrimitiveSelectors includesKey: selector]) ifTrue: [
		^ self perform: (ClassPrimitiveSelectors at: selector) withArguments: (arguments collect: #value)
	].
	ObjectPrimitiveSelectors at: selector ifPresent: [ :implementation |
		(#(castTo: reinterpretCastTo) includes: selector) ifTrue: [
			^ self perform: implementation withArguments: arguments
		].

		^ self perform: implementation withArguments: (arguments collect: #value)
	].

	method := compiler objectModel lookupSelectorFunction value: self behavior value: selector.
	method ifNil: [
		self flag: 'TODO: Send doesNotUnderstand:'.
		sendingNode semanticError: 'Unsupported selector {1} ' format: { selector printString }
	].

	^ method lowtalkValueWithArguments: { self } , (arguments collect: #value)
		types: {self type} , (arguments collect: #type) compiler: aCompiler at: sendingNode