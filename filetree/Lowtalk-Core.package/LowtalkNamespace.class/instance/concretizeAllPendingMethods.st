as yet unclassified
concretizeAllPendingMethods
	pendingMethods values copy do: [ :pending | self concretizeMethod: pending ]