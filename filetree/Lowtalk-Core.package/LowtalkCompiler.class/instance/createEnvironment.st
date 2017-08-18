compiling
createEnvironment
	compilerEnvironment := LowtalkNamespace empty name: #_Compiler.
	compilerEnvironment
		compileTimeOnly: true;
		compiler: self;
		setCompileTimeVariable: #Compiler value: self;
		setCompileTimeVariable: #Structure value: (LowtalkStructureBuilder new compiler: self);
		setCompileTimeVariable: #Namespace value: (LowtalkNamespaceBuilder new compiler: self);
		setCompileTimeVariable: #Global value: (globalBuilder := LowtalkGlobalBuilder new compiler: self);
		setCompileTimeVariable: #Constant value: (LowtalkConstantBuilder new compiler: self).
	LowtalkType addStandardTypesToEnvironment: compilerEnvironment target: compilationTarget.

	voidType := (compilerEnvironment lookSymbol: #Void) value.
	nilType := (compilerEnvironment lookSymbol: #_Nil) value.
	objectType := (compilerEnvironment lookSymbol: #_DynamicObject) value.
	booleanLiteralType := (compilerEnvironment lookSymbol: #_BooleanLiteral) value.
	characterLiteralType := (compilerEnvironment lookSymbol: #_CharacterLiteral) value.
	integerLiteralType := (compilerEnvironment lookSymbol: #_IntegerLiteral) value.
	floatLiteralType := (compilerEnvironment lookSymbol: #_FloatLiteral) value.
	rationalLiteralType := (compilerEnvironment lookSymbol: #_RationalLiteral) value.
	stringLiteralType := (compilerEnvironment lookSymbol: #_StringLiteral) value.
	symbolLiteralType := (compilerEnvironment lookSymbol: #_SymbolLiteral) value.
	uintPointerType := (compilerEnvironment lookSymbol: #UIntPointer) value.
	intPointerType := (compilerEnvironment lookSymbol: #IntPointer) value.
	booleanType := (compilerEnvironment lookSymbol: #BooleanBit) value.
	byteType := (compilerEnvironment lookSymbol: #UInt8) value.
	thisContextType  := (compilerEnvironment lookSymbol: #_ThisContext) value.
	compileTimeType := LowtalkCompileTimeType target: compilationTarget.

	globalEnvironment := 	(LowtalkNamespace parent: compilerEnvironment) name: #_GlobalNamespace.
	globalEnvironment
		compiler: self;
		"setCompileTimeVariable: compilerEnvironment name value: compilerEnvironment;"
		setSymbol: globalEnvironment name value: globalEnvironment
		"setCompileTimeVariable: globalEnvironment name value: globalEnvironment".
		
	compilerEnvironment
		setCompileTimeVariable: globalEnvironment name value: globalEnvironment.