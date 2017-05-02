compiling
createEnvironment
	globalEnvironment := 	LowtalkEnvironment empty.
	globalEnvironment
		setSymbol: #Compiler value: self;
		setSymbol: #GlobalEnvironment value: globalEnvironment
	