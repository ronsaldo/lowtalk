visiting
visitLocalVariableNode: node
	"Create the local variable."
	| variable |
	node valueType: (self solveTypeExpression: node typeExpression defaultType: compiler objectType).

	variable := LowtalkMethodLocalVariable new
		valueType: node valueType;
		name: node name;
		method: method;
		isConstant: false.
	environment setSymbol: variable name value: variable ifPresent: [ 
		node semanticError: 'Local variable name {1} is already in use in the current scope.' format: { variable name printString }
	].

	node binding ifNil: [ node binding: variable ].
	method addTemporary: variable.
	node setTypeIfNil: node valueType ref.
	