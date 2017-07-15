messages
generateMessageWithCompileTimeLookup: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass
	|  calledFunction functionType argumentsBaseIndex argumentValue expectedType arguments function |
	calledFunction := message compileTimeMessageLookup.
	
	functionType := calledFunction type.
	
	"Get the function"
	function := calledFunction asLowtalkObjectInstanceWith: compiler.
	function isCompiledMethodMetaData ifTrue: [ function := function sourceMethod ].

	argumentsBaseIndex := 0.
	arguments := #().
	calledFunction receiverType isVoidType ifFalse: [
		arguments := {self coerceImplicitly: receiver type: receiverType to: calledFunction receiverType at: message}.
		argumentsBaseIndex := 1.
	].

	"Get the arguments"
	arguments := arguments , (message arguments collectWithIndex: [:arg :index |
		argumentValue := self visitNode: arg.
		expectedType := functionType arguments at: index + argumentsBaseIndex.
		self coerceImplicitly: argumentValue type: arg type to: expectedType at: arg
	]).

	^ builder call: function arguments: arguments