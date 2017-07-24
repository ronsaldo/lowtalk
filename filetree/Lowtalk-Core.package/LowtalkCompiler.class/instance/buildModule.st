module construction
buildModule
	| toProcess elementsToCompile |
	self log: 'Building module'.
	ssaModule := SLVMModule new compilationTarget: compilationTarget.
	elementsToCompile := Set new.
	
	[ pendingObjects isNotEmpty ] whileTrue: [
		toProcess := pendingObjects asArray.
		elementsToCompile addAll: toProcess.
		
		toProcess do: [ :object |
			object prepareToCompile
		].
		pendingObjects removeAll.
		elementsToCompile do: #finishCompiling.
	].

	self assert: pendingObjects isEmpty.
	
	