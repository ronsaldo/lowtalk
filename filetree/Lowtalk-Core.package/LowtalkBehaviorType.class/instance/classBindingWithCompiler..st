accessing
classBindingWithCompiler: aCompiler
	^ classBinding ifNil: [classBinding := classObject lowtalkPerform: #binding withArguments: #() types: #() inSuperclass: false node: nil compiler: compiler]