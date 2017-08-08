evaluating
evaluateCompiledMethod: compiledMethod withArguments: evaluationArguments types: evaluationArgumentTypes compiler: aLowtalkCompiler at: aNode
	"Process the receiver"
	| actualArguments actualArgumentTypes receiverValue receiverValueType argumentDefinition convertedArguments |
	actualArguments := evaluationArguments.
	actualArgumentTypes := evaluationArgumentTypes.
	receiverValue := nil.
	
	receiverType isVoidType ifFalse: [ 
		actualArguments ifEmpty: [ 
			aNode semanticError: 'Expected a receiver.'
		].
	
		receiverValue := actualArguments first.
		receiverValueType := actualArgumentTypes first.
		
		receiverValue := receiverValueType convertValue: receiverValue toType: receiverType at: aNode.

		actualArguments := actualArguments allButFirst.
		actualArgumentTypes := actualArgumentTypes allButFirst.
	].

	"Process the arguments"
	actualArguments size ~= arguments size ifTrue: [ 
		aNode semanticError: 'Expected {1} arguments instead of {2} arguments' format: {arguments size asString . actualArguments size asString}
	].

	"Convert the arguments"
	convertedArguments := actualArguments collectWithIndex: [ :arg :index |
		argumentDefinition := arguments at: index.
		(actualArgumentTypes at: index) convertValue: arg toType: argumentDefinition type at: aNode.
	].

	^ compiledMethod valueWithReceiver: receiverValue arguments: convertedArguments