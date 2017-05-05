initialization
buildModule
	| toProcess |
	ssaModule := SLVMModule new compilationTarget: compilationTarget.
	
	[ pendingObjects isNotEmpty ] whileTrue: [
		toProcess := pendingObjects asArray.
		toProcess do: [ :object |
			self processPendingObject: object
		].
		pendingObjects removeAll
	]
	