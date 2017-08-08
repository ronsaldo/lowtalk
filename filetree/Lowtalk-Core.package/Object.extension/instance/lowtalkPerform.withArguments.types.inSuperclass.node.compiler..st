*Lowtalk-Core
lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	^ LowtalkWhiteList dispatchSelector: selector receiver: self arguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler