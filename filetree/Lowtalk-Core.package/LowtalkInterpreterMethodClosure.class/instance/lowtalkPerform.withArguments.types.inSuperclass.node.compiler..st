evaluating
lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	(ValueSelectors includes: selector) ifTrue: [
		^ self lowtalkValueWithArguments: arguments types: argumentTypes compiler: environment compiler at: sendingNode
	].

	(CullSelectors includes: selector) ifTrue: [ 
		self halt
	].

	^ super lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler