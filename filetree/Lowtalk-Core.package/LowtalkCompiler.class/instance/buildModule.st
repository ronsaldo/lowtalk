module construction
buildModule
	| toProcess objectToFinish |
	self log: 'Building module'.
	objectToFinish := SLVMOrderedInsertionSet new.
	
	[ pendingObjects isNotEmpty ] whileTrue: [
		toProcess := pendingObjects asArray.
		pendingObjects removeAll.
		objectToFinish addAll: toProcess.
		
		toProcess do: #prepareToCompile.
		toProcess do: #compileElement.
	].

	objectToFinish do: #finishCompiling.
	self assert: pendingObjects isEmpty.
	
	