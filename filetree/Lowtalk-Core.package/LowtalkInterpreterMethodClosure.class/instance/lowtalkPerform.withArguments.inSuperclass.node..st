evaluating
lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode
	(ValueSelectors includes: selector) ifTrue: [
		^ self lowtalkValueWithArguments: (arguments collect: #value) types: (arguments collect: #type) compiler: environment compiler at: sendingNode
	].

	(CullSelectors includes: selector) ifTrue: [ 
		self halt
	].

	^ super lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode