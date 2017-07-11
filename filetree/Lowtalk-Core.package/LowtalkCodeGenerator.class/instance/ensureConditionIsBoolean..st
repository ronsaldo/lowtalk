as yet unclassified
ensureConditionIsBoolean: condition
	condition type isBooleanType ifTrue: [ ^ condition ].
	condition type isDynamicObjectType ifTrue: [ 
		^ builder dynObjectIdentityNotEquals: condition with: (builder addDynamicLiteral: false)
	].

	self error: 'Compiler error: invalid condition that is supposed to be convertable into a boolean value.'