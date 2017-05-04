*Lowtalk-Core
lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode
	^ LowtalkWhiteList dispatchSelector: selector receiver: self arguments: arguments inSuperclass: superClass node: sendingNode