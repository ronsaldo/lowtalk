module construction
registerVariable: variable objectInstanceValue: object
	objectInstanceVariableNameMap at: object ifAbsentPut: [ variable mangledName asSymbol ].
	objectInstanceVariableMap at: object ifAbsentPut: [ variable ]