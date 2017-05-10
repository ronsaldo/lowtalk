messages
convertValue: value type: type toConditionOf: selector at: message
	| conditionType |
	conditionType := MessageConditionTypes at: selector.
	conditionType = true ifTrue: [ 
		type isBooleanType ifTrue: [ ^ value ].
		self halt.
	].
	conditionType = false ifTrue: [ 
		type isBooleanType ifTrue: [ ^ builder not: value ].
		self halt.
	].
	conditionType = nil ifTrue: [
		self halt.
	].

	self halt