message dispatching
lowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	| time result |
	^ aCompiler profilingInterpreter ifFalse: [ 
		self doLowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
	] ifTrue: [ 
		time := [
			result := self doLowtalkPerform: selector withArguments: arguments types: argumentTypes inSuperclass: superClass node: sendingNode compiler: aCompiler
		] timeToRun asMilliSeconds.

		time > 0 ifTrue: [ 
			FileStream stdout nextPutAll: ('{1} timeToRun ms {2}' format: { selector printString . time asString }); lf.
		].
		result
	]
