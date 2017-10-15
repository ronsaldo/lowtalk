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

	[ pendingObjectsInitializers isNotEmpty ] whileTrue: [
		toProcess := pendingObjectsInitializers asArray.
		pendingObjectsInitializers removeAll.
		toProcess do: #value
	].

	self assert: pendingObjects isEmpty.

	objectToFinish do: #finishCompiling.
	self assert: pendingObjects isEmpty.
	
	