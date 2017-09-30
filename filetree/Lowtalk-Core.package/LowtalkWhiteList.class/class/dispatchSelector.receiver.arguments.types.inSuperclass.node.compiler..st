as yet unclassified
dispatchSelector: selector receiver: receiver arguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	| method actualSuperClass |
	superClass == true ifTrue: [ 
		actualSuperClass := receiver class superclass.
	] ifFalse: [
		superClass == false ifTrue: [ 
			actualSuperClass := receiver class.
		] ifFalse: [ 
			actualSuperClass := superClass.
		]
	].

	AddedMethods at: selector ifPresent: [ :override |
		^ self perform: override withArguments:
			{ selector . receiver .
				LowtalkLazyValue zipValues: arguments types: argumentTypes node: sendingNode.
				actualSuperClass . sendingNode . aCompiler}
	].

	method := actualSuperClass lookupSelector: selector.
	method ifNil: [
		^ sendingNode semanticError: 'Compile time expression calling unexistent selector {1}' format: { selector printString}.
	].

	aCompiler isSandboxed ifTrue: [ 
		self checkMethod: method receiver: receiver node: sendingNode.
	]. 
	
	OverridenMethods at: method ifPresent: [ :override |
		^ self perform: override withArguments: { selector . receiver .
		(LowtalkLazyValue zipValues: arguments types: argumentTypes node: sendingNode).
		actualSuperClass . sendingNode . aCompiler}
	].

	(method hasPragmaNamed: #lazy) ifTrue: [
		^ receiver perform: selector withArguments: (LowtalkLazyValue zipValues: arguments types: argumentTypes node: sendingNode) inSuperclass: actualSuperClass
	] ifFalse: [
		^ receiver perform: selector withArguments: arguments inSuperclass: actualSuperClass
	]