as yet unclassified
scheduleInstallationInBehavior: behavior category: categoryName
	| compiledMethod behaviorType |
	behaviorType := behavior asLowtalkTypeWith: compiler.
	compiledMethod := self compiledMethodForReceiverTypeValue: behaviorType.
	behaviorType pendingMethod: compiledMethod category: categoryName.