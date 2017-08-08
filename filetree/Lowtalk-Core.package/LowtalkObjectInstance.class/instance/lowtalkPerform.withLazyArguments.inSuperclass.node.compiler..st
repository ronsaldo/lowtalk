message dispatching
lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	| time result |
	^ aCompiler profilingInterpreter ifFalse: [ 
		self doLowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	] ifTrue: [ 
		time := [
			result := self doLowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
		] timeToRun asMilliSeconds.

		time > 0 ifTrue: [ 
			aCompiler log: '{1} timeToRun ms {2}' format: { selector printString . time asString }
		].
		result
	]