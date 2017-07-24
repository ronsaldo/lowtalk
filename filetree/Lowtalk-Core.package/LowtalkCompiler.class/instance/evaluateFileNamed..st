compiling
evaluateFileNamed: aFileName
	<compileTime>
	| evaluationTime |
	"self log: 'Evaluating {1}' format: {aFileName}."
	evaluationTime := [ self doEvaluateFileNamed: aFileName ] timeToRun..
	self log: '{1} evaluation time: {2} ms' format: {aFileName . evaluationTime asMilliSeconds asString}.
	