top level entry points
getCurrentReturnContext
	currentReturnContext ifNotNil: [ ^ currentReturnContext ].
	(parentCodeGenerator isNil or: [method hasLocalReturns]) ifTrue: [
		currentReturnContext := self initializationBuilder getThisContext
	] ifFalse: [ 
		currentReturnContext := self captureInClosure: parentCodeGenerator getCurrentReturnContext.
	].

	^ currentReturnContext