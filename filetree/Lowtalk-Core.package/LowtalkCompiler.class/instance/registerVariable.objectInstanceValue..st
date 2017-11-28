module construction
registerVariable: variable objectInstanceValue: object
	objectInstanceVariableNameMap at: object ifPresent: [ ^ self ] ifAbsentPut: [ self registerMangledNameOf: variable ].
	objectInstanceVariableMap at: object ifAbsentPut: [ variable ].
	
	(object isLowtalkBObject and: [ object isLowtalkType and: [ object isAggregateType and: [object bindingVariable isNil ]]]) ifTrue: 	[
		object bindingVariable: variable.
	]