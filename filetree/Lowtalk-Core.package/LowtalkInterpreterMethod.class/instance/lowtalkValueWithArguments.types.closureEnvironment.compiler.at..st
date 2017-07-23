evaluating
lowtalkValueWithArguments: evaluationArguments types: evaluationArgumentTypes closureEnvironment: closureEnvironment compiler: aLowtalkCompiler at: aNode
	| activationEnvironment argumentDefinition convertedArgument argumentVariable result resultType actualArguments actualArgumentTypes receiverValue receiverValueType receiverActivationEnvironment |
	
	"Process the receiver"
	actualArguments := evaluationArguments.
	actualArgumentTypes := evaluationArgumentTypes.
	receiverValue := nil.
	
	receiverActivationEnvironment := closureEnvironment.
	receiverType isVoidType ifFalse: [ 
		actualArguments ifEmpty: [ 
			aNode semanticError: 'Expected a receiver.'
		].
	
		receiverValue := actualArguments first.
		receiverValueType := actualArgumentTypes first.
		
		receiverValue := receiverValueType convertValue: receiverValue toType: receiverType at: aNode.
		receiverActivationEnvironment := (LowtalkReceiverEnvironment parent: closureEnvironment)
			receiverType: receiverType;
			receiver: receiverValue;
			yourself.
		
		actualArguments := actualArguments allButFirst.
		actualArgumentTypes := actualArgumentTypes allButFirst.
	].

	activationEnvironment := LowtalkLocalEnvironment parent: receiverActivationEnvironment.
		
	"Process the arguments"
	actualArguments size ~= arguments size ifTrue: [ 
		aNode semanticError: 'Expected {1} arguments instead of {2} arguments' format: {arguments size asString . actualArguments size asString}
	].

	actualArguments doWithIndex: [ :arg :index |
		argumentDefinition := arguments at: index.
		convertedArgument := (actualArgumentTypes at: index) convertValue: arg toType: argumentDefinition type at: aNode.
		argumentVariable := LowtalkCompileTimeArgumentLocalVariable new
			name: argumentDefinition name;
			value: arg;
			valueType: argumentDefinition type;
			compiler: aLowtalkCompiler;
			yourself.
		activationEnvironment setSymbol: argumentVariable name value: argumentVariable
	].
	
	result := nil.
	hasLocalReturns ifFalse: [ 
		result := LowtalkEvaluator evaluate: node body environment: activationEnvironment.
		resultType := node body type.
	] ifTrue: [ 
		receiverType isVoidType ifFalse: [
			result := receiverValue.
			resultType := receiverType.
		].

		node body expressions ifNotEmpty: [ 
			[
				LowtalkEvaluator evaluate: node body environment: activationEnvironment.
			] on: LowtalkInterpreterReturnException do: [ :returnExc |
				result := returnExc value.
				resultType := returnExc type.
			]
		]
	].
	
	^ returnType isVoidType ifTrue: [nil] ifFalse: [resultType convertValue: result toType: returnType at: node]