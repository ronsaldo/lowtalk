message dispatching
lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode
	| method |
	(self isRegisteredClass and: [ClassPrimitiveSelectors includes: selector]) ifTrue: [
		^ self lowtalkPerform: selector primitivePrefix: #classPrimitive_ withArguments: arguments inSuperclass: superClass node: sendingNode
	].
	(ObjectPrimitiveSelectors includes: selector) ifTrue: [ 
		(selector == #== ) ifTrue: [ ^ self == arguments first value ].
		(selector == #~~ ) ifTrue: [ ^ self ~~ arguments first value ].
		(selector == #castTo: ) ifTrue: [ ^ self primitive_castTo: arguments first ].
		^ self lowtalkPerform: selector primitivePrefix: #primitive_ withArguments: arguments inSuperclass: superClass node: sendingNode
	].

	method := compiler objectModel lookupSelectorFunction value: self behavior value: selector.
	method ifNil: [
		self flag: 'TODO: Send doesNotUnderstand:'.
		sendingNode semanticError: 'Unsupported selector {1} ' format: { selector printString }
	].

	^ method lowtalkValueWithArguments: { self } , (arguments collect: #value)
		types: {self type} , (arguments collect: #type) compiler: nil at: sendingNode