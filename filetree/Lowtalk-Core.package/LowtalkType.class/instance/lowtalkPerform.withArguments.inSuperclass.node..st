message dispatching
lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode
	selector == #class ifTrue: [ ^ self metaType ].
	^ super lowtalkPerform: selector withArguments: arguments inSuperclass: superClass node: sendingNode