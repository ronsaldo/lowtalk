*Lowtalk-Core
lowtalkDispatchSelector: selector arguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	^ sendingNode semanticError: 'Compile time expression calling unexistent selector {1}' format: { selector printString}.