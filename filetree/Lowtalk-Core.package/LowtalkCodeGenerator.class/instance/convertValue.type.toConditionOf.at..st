messages
convertValue: value type: type toConditionOf: selector at: message
	| conditionType |
	conditionType := MessageConditionTypes at: selector.
	conditionType = true ifTrue: [ 
		type isBooleanType ifTrue: [ ^ value ].
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: false) ].
		self halt.
	].
	conditionType = false ifTrue: [ 
		type isBooleanType ifTrue: [ ^ builder lnot: value ].
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityEquals: value with: (builder addDynamicLiteral: false) ].
		self halt.
	].
	conditionType = nil ifTrue: [
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityEquals: value with: (builder addDynamicLiteral: nil) ].
		self halt.
	].
	conditionType = 0 ifTrue: [
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: nil) ].
		self halt.
	].

	self halt