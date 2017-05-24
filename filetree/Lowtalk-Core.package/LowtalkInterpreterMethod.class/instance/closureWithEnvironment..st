as yet unclassified
closureWithEnvironment: aClosureEnvironment
	^ LowtalkInterpreterMethodClosure new definition: self; environment: aClosureEnvironment