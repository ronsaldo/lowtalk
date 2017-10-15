methods
concretizeMethod: aMethod
	| actualMethod |
	actualMethod := aMethod compiledMethodForReceiverTypeValue: self ref.
	pendingMethods removeKey: aMethod selector.
	methodDict at: actualMethod selector put: actualMethod