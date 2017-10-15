as yet unclassified
registerVariableName: variable forMetaClass: metaclassObject
	metaclassVariableNameMap at: metaclassObject ifAbsentPut: [ self registerMangledNameOf: variable ]