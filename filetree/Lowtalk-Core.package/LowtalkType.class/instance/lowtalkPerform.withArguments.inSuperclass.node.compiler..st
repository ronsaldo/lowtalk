message dispatching
lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler
	selector == #class ifTrue: [ ^ self metaType ].
	^ super lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode compiler: aCompiler