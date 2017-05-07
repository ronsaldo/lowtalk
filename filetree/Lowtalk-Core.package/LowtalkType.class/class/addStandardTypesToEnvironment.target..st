adding
addStandardTypesToEnvironment: anEnvironment target: aCompilationTarget
	anEnvironment
		addCompileTimeVariableValue: (LowtalkTypeFloat16 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeFloat32 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeFloat64 target: aCompilationTarget);

		addCompileTimeVariableValue: (LowtalkTypeInt8 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeUInt8 target: aCompilationTarget);

		addCompileTimeVariableValue: (LowtalkTypeInt16 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeUInt16 target: aCompilationTarget);
		
		addCompileTimeVariableValue: (LowtalkTypeInt32 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeUInt32 target: aCompilationTarget);

		addCompileTimeVariableValue: (LowtalkTypeInt64 target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkTypeUInt64 target: aCompilationTarget);
		
		addCompileTimeVariableValue: (LowtalkVoidType target: aCompilationTarget);

		addCompileTimeVariableValue: (LowtalkDynamicObjectType target: aCompilationTarget);
		
		addCompileTimeVariableValue: (LowtalkFloatLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkIntegerLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkRationalLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkStringLiteralType target: aCompilationTarget);
		addCompileTimeVariableValue: (LowtalkSymbolLiteralType target: aCompilationTarget).
		
	aCompilationTarget pointerSize == 4 ifTrue: [ 
		anEnvironment
			setCompileTimeVariable: #IntPointer value: (anEnvironment lookSymbol: #Int32) value;
			setCompileTimeVariable: #UIntPointer value: (anEnvironment lookSymbol: #UInt32) value.
	] ifFalse: [
		anEnvironment
			setCompileTimeVariable: #IntPointer value: (anEnvironment lookSymbol: #Int64) value;
			setCompileTimeVariable: #UIntPointer value: (anEnvironment lookSymbol: #UInt64) value.
	]
