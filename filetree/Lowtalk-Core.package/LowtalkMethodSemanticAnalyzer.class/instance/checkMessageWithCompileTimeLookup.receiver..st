special messages
checkMessageWithCompileTimeLookup: message receiver: receiver
	| function functionType receiverType submittedArguments |
	self assert: message compileTimeMessageLookup isNotNil.
	function := message compileTimeMessageLookup.
	functionType := function type.

	message arguments do: [ :arg | self visitNode: arg ].
	submittedArguments := message arguments collect: #type.
	function receiverType isVoidType ifFalse: [ 
		self halt.
	].

	self checkCall: functionType argumentTypes: submittedArguments at: message.
	message type: functionType returnType.
