as yet unclassified
createObjectVariableHeaderClass: variableClass name: variableName
	| instance |
	compiler objectModel objectVariableHeaderCreationFunction ifNil: [ ^ nil ].
	instance := compiler objectModel objectVariableHeaderCreationFunction 
		lowtalkValueWithArguments: { variableClass headerPointer . variableName }
		types: { compiler objectModel headerType pointer . compiler objectType }
		compiler: compiler at: nil.
	
	^ instance asSSAConstantValueIn: compiler ssaModule