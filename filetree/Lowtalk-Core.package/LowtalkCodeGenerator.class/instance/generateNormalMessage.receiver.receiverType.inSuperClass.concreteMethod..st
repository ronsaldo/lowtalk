messages
generateNormalMessage: message receiver: receiver receiverType: receiverType inSuperClass: inSuperClass concreteMethod: concreteMethod
	"Get the function"
	| function functionType argumentsBaseIndex arguments argumentValue expectedType |
	functionType := concreteMethod type.
	
	function := concreteMethod asLowtalkObjectInstanceWith: compiler.
	function isCompiledMethodMetaData ifTrue: [ function := function sourceMethod ].
	
	argumentsBaseIndex := 0.
	arguments := #().
	concreteMethod receiverType isVoidType ifFalse: [
		arguments := {self coerceImplicitly: receiver type: receiverType to: concreteMethod receiverType at: message}.
		argumentsBaseIndex := 1.
	].

	"Get the arguments"
	arguments := arguments , (message arguments collectWithIndex: [:arg :index |
		argumentValue := self visitNode: arg.
		expectedType := functionType arguments at: index + argumentsBaseIndex.
		self coerceImplicitly: argumentValue type: arg type to: expectedType at: arg
	]).

	^ builder call: function arguments: arguments