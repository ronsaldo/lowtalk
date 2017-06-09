as yet unclassified
dispatchSelector: selector receiver: receiver arguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	| method |
	AddedMethods at: selector ifPresent: [ :override |
		^ self perform: override withArguments: { selector . receiver . arguments . superClass . sendingNode . aCompiler}
	].

	method := superClass lookupSelector: selector.
	method ifNil: [
		^ sendingNode semanticError: 'Compile time expression calling unexistent selector {1}' format: { selector }.
	].

	self checkMethod: method receiver: receiver node: sendingNode.
	
	OverridenMethods at: method ifPresent: [ :override |
		^ self perform: override withArguments: { selector . receiver . arguments . superClass . sendingNode . aCompiler}
	].

	(method hasPragmaNamed: #lazy) ifTrue: [
		^ receiver perform: selector withArguments: arguments inSuperclass: superClass
	] ifFalse: [
		^ receiver perform: selector withArguments: (arguments collect: #value) inSuperclass: superClass
	]