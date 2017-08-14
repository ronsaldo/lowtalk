module construction
buildModule
	| toProcess |
	self log: 'Building module'.
	ssaModule := SLVMModule new compilationTarget: compilationTarget.
	
	[ pendingObjects isNotEmpty ] whileTrue: [
		toProcess := pendingObjects asArray.
		pendingObjects removeAll.
		
		toProcess do: [ :object |
			object prepareToCompile
		].
		toProcess do: #finishCompiling.
	].

	self assert: pendingObjects isEmpty.
	
	