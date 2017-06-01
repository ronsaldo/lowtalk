module construction
registerVariable: variable objectInstanceValue: object
	objectInstanceVariableNameMap at: object ifAbsentPut: [ variable mangledName asSymbol ]