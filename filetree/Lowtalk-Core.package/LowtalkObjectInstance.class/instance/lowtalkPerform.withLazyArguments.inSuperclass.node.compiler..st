message dispatching
lowtalkPerform: selector withLazyArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	^ self doLowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler

	"| time result |
	time := [
		result := self doLowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	] timeToRun asMilliSeconds.

	FileStream stdout nextPutAll: ('{1} timeToRun ms {2}' format: { selector printString . time asString }); lf.
	^ result"