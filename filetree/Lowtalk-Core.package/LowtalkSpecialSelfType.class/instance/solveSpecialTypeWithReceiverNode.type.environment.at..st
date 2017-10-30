as yet unclassified
solveSpecialTypeWithReceiverNode: receiverNode type: receiverType environment: environment at: node
	(receiverNode isSelf or: [ receiverNode isSuper ]) ifTrue: [
		^ self
	].
	^ receiverType evaluateSelfTypeInEnvironment: environment at: node