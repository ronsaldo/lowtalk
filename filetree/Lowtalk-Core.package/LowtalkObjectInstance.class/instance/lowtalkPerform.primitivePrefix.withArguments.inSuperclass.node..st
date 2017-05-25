message dispatching
lowtalkPerform: selector primitivePrefix: prefix withArguments: arguments inSuperclass: superClass node: sendingNode
	| fullSelector |
	fullSelector := (prefix , selector) asSymbol.
	^ self perform: fullSelector withArguments: (arguments collect: #value)