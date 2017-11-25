compiling
evaluateFileNamedInThisContext: aFileName inContext: aLowtalkContext
	<compileTime>
	| evaluationTime result |
	^ self profilingInterpreter ifFalse: [ 
		self doEvaluateFileNamed: aFileName inContext: aLowtalkContext
	] ifTrue: [ 
		evaluationTime := [ result := self doEvaluateFileNamed: aFileName ] timeToRun.
		self log: '{1} evaluation time: {2} ms' format: {aFileName . evaluationTime asMilliSeconds asString}.
		result
	].

	