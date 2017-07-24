top level entry points
getCurrentNonLocalReturnMethod
	currentNonLocalReturnMethod ifNotNil: [ ^ currentNonLocalReturnMethod ].
	(parentCodeGenerator isNil or: [method hasLocalReturns]) ifTrue: [
		currentNonLocalReturnMethod := method
	] ifFalse: [ 
		currentNonLocalReturnMethod := parentCodeGenerator getCurrentNonLocalReturnMethod.
	].

	^ currentNonLocalReturnMethod