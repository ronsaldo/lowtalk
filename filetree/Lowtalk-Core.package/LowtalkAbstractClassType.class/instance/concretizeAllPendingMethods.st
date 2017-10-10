methods
concretizeAllPendingMethods
	pendingMethods values copy do: [ :pending | self concretizeMethod: pending ]