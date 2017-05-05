adding
addStandardTypesToEnvironment: anEnvironment target: aCompilationTarget
	anEnvironment
		setCompileTimeVariable: #Float16 value: (LowtalkTypeFloat16 target: aCompilationTarget);
		setCompileTimeVariable: #Float32 value: (LowtalkTypeFloat32 target: aCompilationTarget);
		setCompileTimeVariable: #Float64 value: (LowtalkTypeFloat64 target: aCompilationTarget);

		setCompileTimeVariable: #Int8 value: (LowtalkTypeInt8 target: aCompilationTarget);
		setCompileTimeVariable: #UInt8 value: (LowtalkTypeUInt8 target: aCompilationTarget);

		setCompileTimeVariable: #Int16 value: (LowtalkTypeInt16 target: aCompilationTarget);
		setCompileTimeVariable: #UInt16 value: (LowtalkTypeUInt16 target: aCompilationTarget);
		
		setCompileTimeVariable: #Int32 value: (LowtalkTypeInt32 target: aCompilationTarget);
		setCompileTimeVariable: #UInt32 value: (LowtalkTypeUInt32 target: aCompilationTarget);

		setCompileTimeVariable: #Int64 value: (LowtalkTypeInt64 target: aCompilationTarget);
		setCompileTimeVariable: #UInt64 value: (LowtalkTypeUInt64 target: aCompilationTarget);
		
		setCompileTimeVariable: #Void value: (LowtalkVoidType target: aCompilationTarget);

		setCompileTimeVariable: #_ObjectType value: (LowtalkDynamicObjectType target: aCompilationTarget).
		
	aCompilationTarget pointerSize == 4 ifTrue: [ 
		anEnvironment
			setCompileTimeVariable: #IntPointer value: (anEnvironment lookSymbol: #Int32) value;
			setCompileTimeVariable: #UIntPointer value: (anEnvironment lookSymbol: #UInt32) value.
	] ifFalse: [
		anEnvironment
			setCompileTimeVariable: #IntPointer value: (anEnvironment lookSymbol: #Int64) value;
			setCompileTimeVariable: #UIntPointer value: (anEnvironment lookSymbol: #UInt64) value.
	]
