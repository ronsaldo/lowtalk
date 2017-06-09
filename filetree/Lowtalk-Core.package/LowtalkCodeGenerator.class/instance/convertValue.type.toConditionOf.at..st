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
		type isPointerType ifTrue: [ ^ builder ieq: value with: (SLVMConstant type: value type value: 0) ].
		self halt.
	].
	conditionType = 0 ifTrue: [
		type isDynamicObjectType ifTrue: [ ^ builder dynObjectIdentityNotEquals: value with: (builder addDynamicLiteral: nil) ].
		type isPointerType ifTrue: [ ^ builder ine: value with: (SLVMConstant type: value type value: 0) ].
		self halt.
	].

	self halt