methods
concretizeMethod: aMethod
	| actualMethod |
	actualMethod := aMethod compiledMethodForReceiverTypeValue: self ref.
	pendingMethods removeKey: aMethod selector.
	methods at: actualMethod selector put: actualMethod