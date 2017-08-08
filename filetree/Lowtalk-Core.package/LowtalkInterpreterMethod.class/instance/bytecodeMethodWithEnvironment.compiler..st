evaluating
bytecodeMethodWithEnvironment: closureEnvironment compiler: aLowtalkCompiler
	| bytecodeMethod |
	bytecodeMethods at: closureEnvironment ifPresent: [ :compiledMethod | ^ compiledMethod ].
	Transcript show: 'Generate compiled method at '; show: node position; cr.
	bytecodeMethod := LowtalkCompiledMethodGenerator new
		compiler: aLowtalkCompiler;
		generateInterpreterMethod: self closureEnvironment: closureEnvironment.
	bytecodeMethods at: closureEnvironment put: bytecodeMethod.
	"self halt."
	^ bytecodeMethod