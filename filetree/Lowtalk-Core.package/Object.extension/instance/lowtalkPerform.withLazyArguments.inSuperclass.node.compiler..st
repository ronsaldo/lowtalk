*Lowtalk-Core
lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	^ LowtalkWhiteList dispatchSelector: selector receiver: self lazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler