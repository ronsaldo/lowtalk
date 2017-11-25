compiling
evaluateFileNamedInThisContext: aFileName
	<compileTime>
	<lazy>
	| evaluationTime result |
	^ self profilingInterpreter ifFalse: [ 
		self doEvaluateFileNamed: aFileName value inContext: thisContext lowtalkContext
	] ifTrue: [ 
		evaluationTime := [ result := self doEvaluateFileNamed: aFileName ] timeToRun.
		self log: '{1} evaluation time: {2} ms' format: {aFileName . evaluationTime asMilliSeconds asString}.
		result
	].

	