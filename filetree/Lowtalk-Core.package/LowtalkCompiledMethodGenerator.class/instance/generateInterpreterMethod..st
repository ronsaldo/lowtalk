as yet unclassified
generateInterpreterMethod: aMethod
	| compiledMethod |
	normalReturnMethod := aMethod.
	method := aMethod.
	selfType := method receiverType.
	
	irBuilder := IRBuilder new.
	irBuilder numArgs: method arguments size.
	
	method arguments do: [ :arg |
		arg compiledMethodVariable: (self convertTemporaryName: arg name).
		irBuilder addTemp: arg compiledMethodVariable.
	].

	method temporaries do: [ :temp |
		temp compiledMethodVariable: (self convertTemporaryName: temp name).
		self initializeTemporary: temp.
	].

	self generateFunctionBody: method node body.
	
	compiledMethod := irBuilder ir compiledMethod.
	method selector ifNotNil: [ compiledMethod selector: method selector ].
	"classBinding := method methodClass classBindingWithCompiler: compiler.
	classBinding ifNotNil: [ method classBinding: classBinding]."
	
	^ compiledMethod