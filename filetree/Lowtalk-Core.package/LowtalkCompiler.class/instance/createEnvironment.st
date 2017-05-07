compiling
createEnvironment
	compilerEnvironment := LowtalkNamespace empty name: #_Compiler.
	compilerEnvironment
		compileTimeOnly: true;
		compiler: self;
		setCompileTimeVariable: #Compiler value: self;
		setCompileTimeVariable: #Structure value: (LowtalkStructureBuilder new compiler: self);
		setCompileTimeVariable: #Namespace value: (LowtalkNamespaceBuilder new compiler: self);
		setCompileTimeVariable: #Global value: (LowtalkGlobalBuilder new compiler: self);
		setCompileTimeVariable: #Constant value: (LowtalkConstantBuilder new compiler: self).
	LowtalkType addStandardTypesToEnvironment: compilerEnvironment target: compilationTarget.

	voidType := (compilerEnvironment lookSymbol: #Void) value.
	objectType := (compilerEnvironment lookSymbol: #_DynamicObject) value.
	integerLiteralType := (compilerEnvironment lookSymbol: #_IntegerLiteral) value.
	floatLiteralType := (compilerEnvironment lookSymbol: #_FloatLiteral) value.
	rationalLiteralType := (compilerEnvironment lookSymbol: #_RationalLiteral) value.
	stringLiteralType := (compilerEnvironment lookSymbol: #_StringLiteral) value.
	symbolLiteralType := (compilerEnvironment lookSymbol: #_SymbolLiteral) value.
	compileTimeType := LowtalkCompileTimeType target: compilationTarget.

	globalEnvironment := 	(LowtalkNamespace parent: compilerEnvironment) name: #_GN.
	globalEnvironment
		compiler: self;
		"setCompileTimeVariable: compilerEnvironment name value: compilerEnvironment;"
		setCompileTimeVariable: globalEnvironment name value: globalEnvironment.
		
	compilerEnvironment
		setCompileTimeVariable: globalEnvironment name value: globalEnvironment.
