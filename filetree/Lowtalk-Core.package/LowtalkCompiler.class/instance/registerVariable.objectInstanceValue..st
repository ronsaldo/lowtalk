module construction
registerVariable: variable objectInstanceValue: object
	| behavior |
	objectInstanceVariableNameMap at: object ifAbsentPut: [ variable mangledName asSymbol ].
	objectInstanceVariableMap at: object ifAbsentPut: [ variable ].
	
	(object isLowtalkBObject and: [ object isObjectInstance and: [ object isRegisteredClass ] ]) ifTrue: 	[
		behavior := object behavior.
		behavior ifNotNil: [ 
			metaclassVariableNameMap at: behavior ifAbsentPut: [ variable mangledName asSymbol ]
		]
	]