evaluating
lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	(ValueSelectors includes: selector) ifTrue: [
		^ self lowtalkValueWithArguments: (arguments collect: #value) types: (arguments collect: #type) compiler: environment compiler at: sendingNode
	].

	(CullSelectors includes: selector) ifTrue: [ 
		self halt
	].

	^ super lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler