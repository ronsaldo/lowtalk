compiling
createEnvironment
	compilerEnvironment := 	LowtalkNamespace empty name: #_Compiler.
	compilerEnvironment
		setSymbol: #Compiler value: self;
		setSymbol: #Structure value: (LowtalkStructureBuilder new compiler: self);
		setSymbol: #Namespace value: (LowtalkNamespaceBuilder new compiler: self).

	globalEnvironment := 	(LowtalkNamespace parent: compilerEnvironment) name: #_Global.
	globalEnvironment
		"setSymbol: compilerEnvironment name value: compilerEnvironment;"
		setSymbol: globalEnvironment name value: globalEnvironment.
		
	compilerEnvironment
		setSymbol: globalEnvironment name value: globalEnvironment.
