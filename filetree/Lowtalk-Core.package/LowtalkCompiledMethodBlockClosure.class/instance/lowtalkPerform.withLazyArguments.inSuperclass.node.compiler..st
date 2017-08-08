message dispatching
lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	(ValueSelectors includes: selector) ifTrue: [
		^ self lowtalkValueWithArguments: (arguments collect: #value) types: (arguments collect: #type) compiler: aCompiler at: sendingNode
	].

	(CullSelectors includes: selector) ifTrue: [ 
		self halt
	].

	^ super lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler