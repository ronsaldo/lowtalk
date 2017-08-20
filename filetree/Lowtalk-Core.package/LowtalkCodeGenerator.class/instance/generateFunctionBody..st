top level entry points
generateFunctionBody: body
	| result |
	result := self visitNode: body.
	
	initializationBlock ifNotNil: [ 
		allocaBuilder jump: initializationBlock.
		initializationBuilder jump: bodyBlock
	] ifNil: [ 
		allocaBuilder jump: bodyBlock.
	].
	
	builder isLastTerminator ifFalse: [
		method hasLocalReturns ifTrue: [ 
			self tryToReturnImplicitly: selfValue type: selfType
		] ifFalse: [ 
			self tryToReturnImplicitly: result type: body type
		]

	].

	(method selector isNotNil or:
	[ (method methodClass classBindingWithCompiler: compiler) isNotNil
	or: [ currentFunction dynamicLiterals isNotEmpty ]]) ifTrue: [ 
		currentFunction
			addRequiredDynamicLiteral: method selector;
			addRequiredDynamicLiteral: (method methodClass classBindingWithCompiler: compiler).

	].
	
	"Create the function context metadata"
	currentFunction dynamicLiterals do: [ :literal | compiler convertDynamicObjectSSAConstant: literal value ].
