accessing
specialMessageTypeForSelector: selector environment: environment at: node
	| actualType |
	actualType := self evaluateInEnvironment: environment at: node.
	^ actualType specialMessageTypeForSelector: selector environment: environment at: node