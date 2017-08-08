compiling
evaluateFileNamed: aFileName
	<compileTime>
	| evaluationTime result |
	^ self profilingInterpreter ifFalse: [ 
		self doEvaluateFileNamed: aFileName
	] ifTrue: [ 
		evaluationTime := [ result := self doEvaluateFileNamed: aFileName ] timeToRun.
		self log: '{1} evaluation time: {2} ms' format: {aFileName . evaluationTime asMilliSeconds asString}.
		result
	].

	